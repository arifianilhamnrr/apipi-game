extends CanvasLayer

var panel: Control
var score_label: Label
var sub_label: Label

func _ready() -> void:
	panel = find_child("PanelContainer", true, false)
	score_label = find_child("FinalScoreLabel", true, false)
	sub_label = find_child("SubLabel", true, false)
	if panel:
		panel.visible = false

func show_victory() -> void:
	if panel:
		var hud = get_tree().get_first_node_in_group("hud")
		if hud and score_label:
			score_label.text = "Skor Akhir: %d  |  Total Buah: %d" % [hud.score, hud.fruits]
		panel.visible = true
		panel.modulate.a = 0.0
		panel.scale = Vector2(0.8, 0.8)
		panel.pivot_offset = panel.size / 2.0
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, 0.4)
		tween.parallel().tween_property(panel, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
