extends HBoxContainer

@onready var question_text: Label = $QuestionText
@onready var submit_button: Button = $SubmitButton

var question: Question

func _ready() -> void:
	question_text.text = question.main_text

func init(question: Question):
	self.question = question

func _on_submit_button_pressed() -> void:
	QuestionManager.emit_load_question.rpc(inst_to_dict(question))
