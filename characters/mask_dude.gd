extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite2d = $AnimatedSprite2D
@onready var spawn_position: Vector2 = global_position

func _ready() -> void:
	add_to_group("player")
	if sprite2d:
		sprite2d.play("Idle")

func respawn() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	if has_node("Camera2D"):
		$Camera2D.reset_smoothing()

func bounce(force: float = -620.0) -> void:
	velocity.y = force

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite2d.animation = "Jump"
	else:
		if abs(velocity.x) > 1.0:
			sprite2d.animation = "Run"
		else:
			sprite2d.animation = "Idle"

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
