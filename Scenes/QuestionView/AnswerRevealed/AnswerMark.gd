extends VBoxContainer

@onready var answer_label: Label = $AnswerLabel

var answer: String
var question: Question

func _ready() -> void:
	answer_label.text = answer

func init(question: Question, answer: String):
	self.question = question
	self.answer = answer

func _on_check_box_toggled(button_pressed: bool) -> void:
	if button_pressed:
		AnswerManager.increase_answer_score.rpc_id(1, question.id, Utils.personal_id, 1)
	else:
		AnswerManager.increase_answer_score.rpc_id(1, question.id, Utils.personal_id, -1)
		
