extends QuestionBase

@onready var center: Control = $Center

var lines: Array = []
var left_mouse_pressed: bool = false

var brush_color: Color = Color.BLACK
var brush_width: int = 1
var canvas_color: Color = Color.WHITE

func _input(event: InputEvent) -> void:
	var mouse_event = event as InputEventMouse
	if event.is_action_pressed("left_mouse"):
		left_mouse_pressed = true
		add_new_line(brush_color, brush_width)
	if event.is_action_released("left_mouse"):
		left_mouse_pressed = false
	
	if event is InputEventMouseMotion and left_mouse_pressed:
		var local_position = center.get_local_mouse_position()
		if local_position.x < -250 or local_position.x > 250:
			add_new_line(brush_color, brush_width)
			return
		if local_position.y < -250 or local_position.y > 250:
			add_new_line(brush_color, brush_width)
			return
		lines.back().points.append(local_position)
		
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(center.position + Vector2(-250,-250),  Vector2(500,500)), canvas_color)
	
	# translate points to be relative to the canvas center
	var transform = Transform2D(0, -center.position)
	for line in lines:
		if line.points.size() > 1:
			draw_polyline(line.points * transform, line.color, line.width, false)

func add_new_line(color: Color, width: int):
	lines.append({
		"color": color,
		"width": width,
		"points": PackedVector2Array()
	})

func _on_brush_color_color_changed(color: Color) -> void:
	brush_color = color

func _on_canvas_color_color_changed(color: Color) -> void:
	canvas_color = color
	queue_redraw()

func _on_brush_width_value_changed(value: float) -> void:
	brush_width = value
