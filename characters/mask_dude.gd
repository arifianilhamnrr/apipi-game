extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite2d = $AnimatedSprite2D
@onready var spawn_position: Vector2 = global_position
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if (velocity.x > 1 || velocity.x < -1):
		sprite2d.animation = "Run"
	else: 
		sprite2d.animation = "Idle"
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite2d.animation = "Jump"
		var isleft = velocity.x < 0
		sprite2d.flip_h = isleft
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		sprite2d.flip_h = direction < 0
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if global_position.y > 800 or Input.is_action_just_pressed("Respawn"):
		global_position = spawn_position
		velocity = Vector2.ZERO
		$Camera2D.reset_smoothing()
