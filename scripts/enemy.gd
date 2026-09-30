extends CharacterBody2D

@export var speed: float = 60.0
@export var patrol_distance: float = 90.0

var start_x: float = 0.0
var direction: int = 1
var is_dead: bool = false
var sprite: AnimatedSprite2D

func _ready() -> void:
	start_x = position.x
	add_to_group("enemy")
	sprite = get_node_or_null("AnimatedSprite2D")
	if sprite == null:
		for child in get_children():
			if child is AnimatedSprite2D:
				sprite = child
				break
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("run"):
		sprite.play("run")

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if abs(position.x - start_x) >= patrol_distance:
		direction = -1 if position.x > start_x else 1
		
	if is_on_wall():
		direction = -direction
		
	velocity.x = direction * speed
	if sprite:
		sprite.flip_h = direction > 0
		
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_dead or not body.is_in_group("player"):
		return
		
	# Check stomp from above
	if body.velocity.y > 0.0 and body.global_position.y < global_position.y - 2.0:
		is_dead = true
		velocity = Vector2.ZERO
		body.bounce(-480.0)
		get_tree().call_group("hud", "add_score", 200)
		if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("hit"):
			sprite.play("hit")
		var tween = create_tween()
		tween.tween_property(self, "scale:y", 0.2, 0.15)
		tween.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
		tween.tween_callback(queue_free)
	else:
		if body.has_method("respawn"):
			body.respawn()
