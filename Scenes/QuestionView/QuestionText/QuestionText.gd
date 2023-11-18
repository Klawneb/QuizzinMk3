extends QuestionBase

@onready var main_text: Label = $VBoxContainer/MainText

func _ready() -> void:
	main_text.text = question.main_text
