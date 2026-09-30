extends CanvasLayer

var score: int = 0
var fruits: int = 0

@onready var score_label: Label = find_child("ScoreLabel", true, false)
@onready var fruits_label: Label = find_child("FruitsLabel", true, false)

func _ready() -> void:
	add_to_group("hud")
	update_display()

func add_fruit(points: int = 100) -> void:
	score += points
	fruits += 1
	update_display()
	if fruits_label:
		var tween = create_tween()
		fruits_label.scale = Vector2(1.2, 1.2)
		tween.tween_property(fruits_label, "scale", Vector2.ONE, 0.2)

func add_score(points: int) -> void:
	score += points
	update_display()

func update_display() -> void:
	if score_label:
		score_label.text = "★ SCORE: %06d" % score
	if fruits_label:
		fruits_label.text = "🍎 FRUITS: %d" % fruits
