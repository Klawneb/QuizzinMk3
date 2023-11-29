extends QuestionBase

@onready var center: Control = $Center
@onready var prompt_label: Label = $Center/PromptContainer/PromptLabel
@onready var distribute_prompts_button: Button = $DistributePromptsButton
@onready var prompt_container: VBoxContainer = $Center/PromptContainer

var lines: Array = []
var left_mouse_pressed: bool = false

var brush_color: Color = Color.BLACK
var brush_width: int = 3
var canvas_color: Color = Color.WHITE
var prompt: String = ""
var id: String = uuid.v4()

func _ready() -> void:
	QuestionManager.prompt_received.connect(on_prompt_received)
	
	if is_multiplayer_authority():
		distribute_prompts_button.visible = true

func _input(event: InputEvent) -> void:
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

func on_prompt_received(prompt: String):
	prompt_container.visible = true
	prompt_label.text = prompt
	self.prompt = prompt

func _on_distribute_prompts_button_pressed() -> void:
	QuestionManager.distribute_prompts(question.prompts)

func _on_button_pressed() -> void:
	QuestionManager.add_art_question.rpc_id(1, NetworkManager.username, lines, prompt, canvas_color, id)
