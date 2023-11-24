extends QuestionBase

@onready var main_text: Label = $HBoxContainer/VBoxContainer/MainText
@onready var texture_rect: TextureRect = $HBoxContainer/VBoxContainer2/TextureRect

func _ready() -> void:
	main_text.text = question.main_text
	texture_rect.texture = load(question.image_path)
