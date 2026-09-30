extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_VELOCITY = -370.0

var jump_count: int = 0
var max_jumps: int = 2
var jump_held: bool = false

var max_lives: int = 3
var lives: int = 3
var is_invulnerable: bool = false

var sprite2d: AnimatedSprite2D
@onready var spawn_position: Vector2 = global_position
var start_position: Vector2

func _ready() -> void:
	add_to_group("player")
	start_position = global_position
	sprite2d = get_node_or_null("AnimatedSprite2D")
	if sprite2d == null:
		for child in get_children():
			if child is AnimatedSprite2D:
				sprite2d = child
				break
	if sprite2d:
		sprite2d.play("Idle")
	get_tree().call_group("hud", "update_lives", lives)

func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	jump_count = 0
	if has_node("Camera2D"):
		$Camera2D.reset_smoothing()

func hit_by_enemy() -> void:
	if is_invulnerable:
		return
		
	lives -= 1
	get_tree().call_group("hud", "update_lives", lives)
	
	if lives <= 0:
		# Reset to the very beginning of the level!
		lives = max_lives
		spawn_position = start_position
		get_tree().call_group("hud", "update_lives", lives)
		respawn()
		_start_invulnerability(1.5)
	else:
		# Respawn at latest checkpoint
		respawn()
		_start_invulnerability(1.5)

func _start_invulnerability(duration: float = 1.5) -> void:
	is_invulnerable = true
	if sprite2d:
		var tween = create_tween()
		for i in range(5):
			tween.tween_property(sprite2d, "modulate:a", 0.3, 0.15)
			tween.tween_property(sprite2d, "modulate:a", 1.0, 0.15)
		tween.tween_callback(func(): is_invulnerable = false)
	else:
		is_invulnerable = false

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
	var pressed := Input.is_action_pressed("ui_accept") \
		or Input.is_action_pressed("ui_up") \
		or Input.is_physical_key_pressed(KEY_SPACE) \
		or Input.is_physical_key_pressed(KEY_W) \
		or Input.is_physical_key_pressed(KEY_UP)
	if pressed:
		if not jump_held:
			jump_held = true
			return true
		return false
	else:
		jump_held = false
		return false

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif velocity.y >= 0:
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

	move_and_slide()

	# Animations: single Jump in air, Double Jump only on double jump, Run/Idle on floor
	if sprite2d:
		if not is_on_floor():
			if sprite2d.animation == "Double Jump" and sprite2d.is_playing():
				pass
			else:
				sprite2d.play("Jump")
		else:
			if abs(velocity.x) > 1.0:
				sprite2d.play("Run")
			else:
				sprite2d.play("Idle")

	# Fall check / Respawn hotkey
	if global_position.y > 750 or Input.is_action_just_pressed("Respawn") or Input.is_physical_key_pressed(KEY_R) or Input.is_key_pressed(KEY_R):
		respawn()
