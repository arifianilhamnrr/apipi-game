extends Area2D

var collected: bool = false
var sprite: AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	sprite = get_node_or_null("AnimatedSprite2D")
	if sprite == null:
		for child in get_children():
			if child is AnimatedSprite2D:
				sprite = child
				break

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if body.is_in_group("player") or body.has_method("respawn"):
		collected = true
		if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("collected"):
			sprite.play("collected")
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y - 14.0, 0.3)
		tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)
		tween.tween_callback(queue_free)
