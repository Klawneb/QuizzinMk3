extends QuestionBase

@onready var center: Control = $Center
@onready var main_text: Label = $MainText

var lines: Array
var canvas_color: Color = Color.WHITE

func _ready() -> void:
	lines = question.line_data
	canvas_color = question.canvas_color
	main_text.text = question.main_text

func _draw() -> void:
	draw_rect(Rect2(center.position + Vector2(-250,-250),  Vector2(500,500)), canvas_color)
	
	# translate points to be relative to the canvas center
	var transform = Transform2D(0, -center.position)
	for line in lines:
		if line.points.size() > 1:
			draw_polyline(line.points * transform, line.color, line.width, false)
