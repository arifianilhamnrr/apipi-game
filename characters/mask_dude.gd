extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_VELOCITY = -370.0

var jump_count: int = 0
var max_jumps: int = 2
var jump_held: bool = false

var sprite2d: AnimatedSprite2D
@onready var spawn_position: Vector2 = global_position

func _ready() -> void:
	add_to_group("player")
	sprite2d = get_node_or_null("AnimatedSprite2D")
	if sprite2d == null:
		for child in get_children():
			if child is AnimatedSprite2D:
				sprite2d = child
				break
	if sprite2d:
		sprite2d.play("Idle")

func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	jump_count = 0
	if has_node("Camera2D"):
		$Camera2D.reset_smoothing()

func bounce(force: float = -620.0) -> void:
	velocity.y = force
	jump_count = 1
	if sprite2d:
		sprite2d.play("Jump")

func get_movement_direction() -> float:
	var dir := Input.get_axis("ui_left", "ui_right")
	if dir == 0.0:
		if Input.is_physical_key_pressed(KEY_A) or Input.is_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_LEFT):
			dir -= 1.0
		if Input.is_physical_key_pressed(KEY_D) or Input.is_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_RIGHT):
			dir += 1.0
	return clampf(dir, -1.0, 1.0)

func is_jump_just_pressed() -> bool:
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		return true
	var raw_jump := Input.is_physical_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_SPACE) \
		or Input.is_physical_key_pressed(KEY_W) or Input.is_key_pressed(KEY_W) \
		or Input.is_physical_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_UP)
	if raw_jump:
		if not jump_held:
			jump_held = true
			return true
	else:
		jump_held = false
	return false

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	# Handle jump & double jump
	if is_jump_just_pressed():
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
			if sprite2d:
				sprite2d.play("Jump")
		elif jump_count < max_jumps:
			velocity.y = DOUBLE_JUMP_VELOCITY
			jump_count += 1
			if sprite2d:
				sprite2d.play("Double Jump")

	# Horizontal movement
	var direction := get_movement_direction()
	if direction < 0:
		if sprite2d:
			sprite2d.flip_h = true
		velocity.x = direction * SPEED
	elif direction > 0:
		if sprite2d:
			sprite2d.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animations
	if sprite2d:
		if not is_on_floor():
			if sprite2d.animation == "Double Jump" and sprite2d.is_playing():
				pass
			elif velocity.y > 0 and sprite2d.sprite_frames.has_animation("Fall"):
				sprite2d.play("Fall")
			else:
				if sprite2d.animation != "Double Jump":
					sprite2d.play("Jump")
		else:
			if abs(velocity.x) > 1.0:
				sprite2d.play("Run")
			else:
				sprite2d.play("Idle")

	move_and_slide()

	# Fall check / Respawn hotkey
	if global_position.y > 750 or Input.is_action_just_pressed("Respawn") or Input.is_physical_key_pressed(KEY_R) or Input.is_key_pressed(KEY_R):
		respawn()
