extends Area2D

var activated: bool = false
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
	if activated:
		return
	if body.is_in_group("player") or body.has_method("respawn"):
		activated = true
		if "spawn_position" in body:
			body.spawn_position = global_position
		if sprite:
			sprite.play("flag_idle")
