class_name Player extends CharacterBody2D

#================== ENUM =============================
enum PlayerState {
	idle,
	disable,
	running,
	falling,
	jumping,
	pulling,
	throw,
	spin
}
var state : PlayerState
#================== CONSTANTS =======================
const LAUNCH_FORCE : float = 3.5
const JUMP_FORCE : float = 200.0
const MAX_PULL_DISTANCE : float = 60.0
const MAX_FALL_SPEED : float = 350.0
const MAX_SPEED : float = 140.0
#================ VARIABLES ==========================
var buffer_jump : bool
var coyote_jump : bool
var direction : float
var gravity : float = 9.8
var throw : bool = false
var room : RoomArea
#================ ONREADY ===========================
@onready var animator: AnimationPlayer = $Animator
@onready var circle_sprite: Sprite2D = $Spear/CircleSprite
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_timer: Timer = $BufferTimer
@onready var sprite: Sprite2D = $Sprite
@onready var spear: Node2D = $Spear
@onready var spear_sprite: Sprite2D = $Spear/SpearSprite
@onready var throw_timer: Timer = $ThrowTimer
@onready var launch_particles: GPUParticles2D = $LaunchParticles
@onready var take_damage_box: Area2D = $TakeDamageBox
@onready var spear_area: Area2D = $Spear/SpearSprite/SpearArea
#=============== REGULAR FUNCTIONS =================
func _ready() -> void:
	buffer_timer.connect("timeout", _on_buffer_timeout)
	coyote_timer.connect("timeout", _on_coyote_timeout)
	throw_timer.connect("timeout", _on_throw_timeout)
	take_damage_box.connect("area_entered", _take_damage)
	spear_area.connect("area_entered", _on_spear_entered)
func _process(delta: float) -> void:
	if state != PlayerState.disable:
		_animaton()
func _physics_process(delta: float) -> void:
	if state != PlayerState.disable:
		match state:
			PlayerState.pulling:
				pull()
				_gravity()
				if Input.is_action_just_released("leftMouse"):
					SignalManager.emit_signal("camera_shake")
					circle_sprite.visible = false
					Engine.time_scale = 1
					set_state(PlayerState.throw)
					launch()
			PlayerState.throw:
				spear_sprite.rotation = velocity.angle() + PI/2
				spear_sprite.offset.y = 0
				if not throw:
					_gravity()
					launch_particles.emitting = false
					if is_on_floor() or is_on_wall():
						velocity = Vector2.ZERO
						circle_sprite.visible = true
						spear.visible = false
						SignalManager.emit_signal("camera_shake")
						set_state(PlayerState.idle)
		if state not in [PlayerState.throw, PlayerState.pulling]:
			direction = Input.get_axis("left", "right")
			if direction != 0.0:
				acceleration()
			else:
				deceleration()
			if is_on_floor() || coyote_jump:
				if Input.is_action_just_pressed("jump") || buffer_jump:
					jump()
			else:
				if Input.is_action_just_pressed("jump"):
					buffer_jump = true
					buffer_timer.start()
				if Input.is_action_just_released("jump") && velocity.y < 0:
					velocity.y = 0
				_gravity()
			if Input.is_action_just_pressed("leftMouse"):
				spear.visible = true
				Engine.time_scale = 0.3
				set_state(PlayerState.pulling)
		var was_on_ground = is_on_floor()
		move_and_slide()
		var just_left_ground = !is_on_floor() && was_on_ground
		if just_left_ground && velocity.y >= 0:
			coyote_jump = true
			coyote_timer.start()

#================== SIGNALS =================================
func _on_coyote_timeout() -> void:
	coyote_jump = false
func _on_buffer_timeout() -> void:
	buffer_jump = false
func _on_throw_timeout() -> void:
	throw = false
func _take_damage(area : Area2D) -> void:
	if area.owner is not Player:
		call_deferred("die")
func _on_spear_entered(area : Area2D) -> void:
	if state == PlayerState.throw:
		SignalManager.emit_signal("camera_shake")
		air_spin()
#================== STATE FUNCTIONS ===========================
func set_state(new_state: PlayerState) -> void:
	var previous_state := state
	state = new_state
#================== CUSTOM FUNCTIONS =========================
func set_room(new_room : RoomArea) -> void:
	room = new_room
func _animaton() -> void:
	if not state in [PlayerState.throw, PlayerState.pulling]:
		if direction > 0.0:
			sprite.flip_h = false
		elif direction < 0.0:
			sprite.flip_h = true
		if is_on_floor():
			if direction == 0:
				animator.play("idle")
				state = PlayerState.idle
			else:
				animator.play("run")
				state = PlayerState.running
		else:
			if state != PlayerState.spin:
				if velocity.y < 0 and Input.is_action_just_pressed("jump"):
					animator.play("jump")
					state = PlayerState.jumping
				elif velocity.y > 0 and state != PlayerState.falling:
					animator.play("fall")
					state = PlayerState.falling
	elif state == PlayerState.pulling:
		var mouse_position = get_global_mouse_position() - spear.global_position
		if mouse_position.x < 0:
			sprite.flip_h = false
		elif mouse_position.x> 0:
			sprite.flip_h = true
		var mouse_angle = mouse_position.angle()
		if mouse_position.y < -25 and mouse_position.y >= -50:
			animator.play("downside_aim")
		elif mouse_position.y > 25 and mouse_position.y <= 50:
			animator.play("upside_aim")
		elif mouse_position.y < -50:
			animator.play("down_aim")
		elif mouse_position.y > 50:
			animator.play("up_aim")
		else:
			animator.play("side_aim")
	elif state == PlayerState.throw:
		var velocity_angle = abs(velocity.angle() + PI/2)
		if velocity_angle >= PI:
			velocity_angle = (2 * PI - velocity_angle)
		if velocity_angle >= 0  and velocity_angle < PI/6:
			animator.play("up_aim")
		elif velocity_angle >= PI/6 and velocity_angle < PI/3:
			animator.play("upside_aim")
		elif velocity_angle >= PI/3 and velocity_angle < 2 * PI / 3:
			animator.play("side_aim")
		elif velocity_angle >= 2 * PI / 3 and velocity_angle < 5 * PI / 6:
			animator.play("downside_aim")
		elif velocity_angle >= 5 * PI / 6 and velocity_angle < PI:
			animator.play("down_aim")
func air_spin() -> void:
	set_state(PlayerState.spin)
	spear.visible = false
	circle_sprite.visible = true
	jump()
	animator.play("spin")
func die() -> void:
	state = PlayerState.disable
	spear.visible = false
	Engine.time_scale = 1.0
	SignalManager.emit_signal("camera_shake")
	global_position = room.respawn_position
	set_state(PlayerState.idle)
func pull() -> void:
	velocity = Vector2.ZERO
	var mouse_position = get_global_mouse_position()
	if mouse_position.distance_to(spear.global_position) > MAX_PULL_DISTANCE:
		mouse_position = (mouse_position - spear.global_position).normalized() * MAX_PULL_DISTANCE + spear.global_position
	spear_sprite.rotation = (mouse_position - spear.global_position).angle() - PI/2
	spear_sprite.offset.y = (mouse_position.distance_to(spear.global_position))/10
	circle_sprite.global_position = mouse_position
func launch() -> void:
	throw = true
	throw_timer.start()
	launch_particles.emitting = true
	var mouse_position = get_global_mouse_position()
	var distance = mouse_position.distance_to(spear.global_position)
	var launch_direction = (mouse_position - spear.global_position).normalized()
	distance = clampf(distance, -MAX_PULL_DISTANCE, MAX_PULL_DISTANCE)
	velocity = -launch_direction * distance * LAUNCH_FORCE
func acceleration() -> void:
	velocity.x = lerpf(velocity.x, direction * MAX_SPEED, 0.1)
func deceleration() -> void:
	velocity.x = lerpf(velocity.x, 0, 0.3)
func _gravity() -> void:
	velocity.y += gravity
	if velocity.y >= MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED	
func jump() -> void:
	set_state(PlayerState.jumping)
	velocity.y = -JUMP_FORCE
func knockback(knockback_strength : float, knockback_direction : Vector2) -> void:
	pass
