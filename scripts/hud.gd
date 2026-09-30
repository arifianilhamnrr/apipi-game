extends CanvasLayer

var score: int = 0
var fruits: int = 0

@onready var score_val: Label = find_child("ScoreValue", true, false)
@onready var fruits_val: Label = find_child("FruitsValue", true, false)

func _ready() -> void:
	add_to_group("hud")
	update_display()

func add_fruit(points: int = 100) -> void:
	score += points
	fruits += 1
	update_display()
	_pop(fruits_val)
	_pop(score_val)

func add_score(points: int) -> void:
	score += points
	update_display()
	_pop(score_val)

func _pop(node: Control) -> void:
	if node:
		node.pivot_offset = node.size / 2.0
		var tween = create_tween()
		tween.tween_property(node, "scale", Vector2(1.25, 1.25), 0.08)
		tween.tween_property(node, "scale", Vector2.ONE, 0.12)

func update_display() -> void:
	if score_val:
		score_val.text = "%06d" % score
	if fruits_val:
		fruits_val.text = "%d" % fruits
