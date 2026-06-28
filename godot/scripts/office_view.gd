extends Control


func _ready() -> void:
	custom_minimum_size = Vector2(320, 220)


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, Color("#1b1d23"))
	draw_rect(Rect2(0, size.y * 0.62, size.x, size.y * 0.38), Color("#2f2a24"))
	draw_rect(Rect2(size.x * 0.08, size.y * 0.58, size.x * 0.84, size.y * 0.12), Color("#6b533d"))

	var monitor := Rect2(size.x * 0.30, size.y * 0.18, size.x * 0.40, size.y * 0.30)
	draw_rect(monitor, Color("#101418"))
	draw_rect(monitor.grow(-8), Color("#263542"))
	draw_rect(Rect2(monitor.position + Vector2(18, 22), Vector2(monitor.size.x - 36, 8)), Color("#ff5c5c"))
	draw_rect(Rect2(monitor.position + Vector2(18, 42), Vector2(monitor.size.x - 70, 8)), Color("#ffd166"))
	draw_rect(Rect2(monitor.position + Vector2(18, 62), Vector2(monitor.size.x - 50, 8)), Color("#5ce1a8"))

	draw_rect(Rect2(size.x * 0.47, size.y * 0.49, size.x * 0.06, size.y * 0.10), Color("#14171c"))
	draw_rect(Rect2(size.x * 0.38, size.y * 0.58, size.x * 0.24, size.y * 0.03), Color("#14171c"))

	_draw_note(Vector2(size.x * 0.08, size.y * 0.12), Color("#ffe680"))
	_draw_note(Vector2(size.x * 0.78, size.y * 0.16), Color("#ff9fb3"))
	_draw_paper(Vector2(size.x * 0.12, size.y * 0.72), -0.08)
	_draw_paper(Vector2(size.x * 0.68, size.y * 0.70), 0.06)

	var font := get_theme_default_font()
	if font:
		draw_string(font, Vector2(18, size.y - 18), "SEV-2  /  read clues, edit code, prove deploy", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("#d7e0ea"))


func _draw_note(position: Vector2, color: Color) -> void:
	draw_rect(Rect2(position, Vector2(48, 42)), color)
	draw_rect(Rect2(position + Vector2(6, 9), Vector2(30, 3)), Color("#5f5640"))
	draw_rect(Rect2(position + Vector2(6, 19), Vector2(35, 3)), Color("#5f5640"))


func _draw_paper(position: Vector2, angle: float) -> void:
	var transform := Transform2D(angle, position)
	draw_set_transform_matrix(transform)
	draw_rect(Rect2(Vector2.ZERO, Vector2(74, 58)), Color("#e8e1d1"))
	draw_rect(Rect2(Vector2(10, 12), Vector2(52, 3)), Color("#4f5760"))
	draw_rect(Rect2(Vector2(10, 24), Vector2(42, 3)), Color("#4f5760"))
	draw_rect(Rect2(Vector2(10, 36), Vector2(58, 3)), Color("#4f5760"))
	draw_set_transform_matrix(Transform2D())
