extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_JUMP_VELOCITY = -370.0

var jump_count: int = 0
var max_jumps: int = 2

@onready var sprite2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_position: Vector2 = global_position

func _ready() -> void:
	add_to_group("player")
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

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	# Handle jump & double jump
	if Input.is_action_just_pressed("ui_accept"):
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

	# Animations
	if not is_on_floor():
		if sprite2d:
			if sprite2d.animation == "Double Jump" and sprite2d.is_playing():
				pass
			elif velocity.y > 0 and sprite2d.sprite_frames.has_animation("Fall"):
				sprite2d.animation = "Fall"
			else:
				if sprite2d.animation != "Double Jump":
					sprite2d.animation = "Jump"
	else:
		if abs(velocity.x) > 1.0:
			sprite2d.animation = "Run"
		else:
			sprite2d.animation = "Idle"

	# Handle horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		sprite2d.flip_h = direction < 0
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Fall check / Respawn hotkey
	if global_position.y > 750 or Input.is_action_just_pressed("Respawn"):
		respawn()
