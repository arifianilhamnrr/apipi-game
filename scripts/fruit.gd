extends Area2D

const SFX_FRUIT = preload("res://assets/Audio/fruit.wav")

@export var points: int = 100
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

func _play_fruit_sfx() -> void:
	var sfx = AudioStreamPlayer.new()
	sfx.stream = SFX_FRUIT
	sfx.volume_db = -3.0
	var parent_node: Node = get_tree().current_scene
	if parent_node == null:
		parent_node = get_parent()
	if parent_node:
		parent_node.add_child(sfx)
		sfx.play()
		sfx.finished.connect(sfx.queue_free)

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if body.is_in_group("player") or body.has_method("respawn"):
		collected = true
		get_tree().call_group("hud", "add_fruit", points)
		_play_fruit_sfx()
		if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("collected"):
			sprite.play("collected")
		var tween = create_tween()
		tween.tween_property(self, "position:y", position.y - 14.0, 0.3)
		tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)
		tween.tween_callback(queue_free)
