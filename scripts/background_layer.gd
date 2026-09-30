extends CanvasLayer

var texture_rect: TextureRect

func _ready() -> void:
	layer = -100
	texture_rect = get_node_or_null("TextureRect")
	if texture_rect == null:
		for child in get_children():
			if child is TextureRect:
				texture_rect = child
				break

func _process(_delta: float) -> void:
	var cam = get_viewport().get_camera_2d()
	if cam and texture_rect:
		var cam_x = cam.get_screen_center_position().x
		var shift = fmod(cam_x * 0.2, 64.0)
		texture_rect.position.x = -shift
