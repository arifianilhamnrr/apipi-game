extends CanvasLayer

var panel: Control

func _ready() -> void:
	panel = find_child("PanelContainer", true, false)
	if panel:
		panel.visible = false

func show_victory() -> void:
	if panel:
		panel.visible = true
		panel.modulate.a = 0.0
		panel.scale = Vector2(0.8, 0.8)
		panel.pivot_offset = panel.size / 2.0
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, 0.4)
		tween.parallel().tween_property(panel, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
