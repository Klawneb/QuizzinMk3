extends QuestionBase

@onready var answer_input: LineEdit = $InputContainer/AnswerInput


func _on_submit_button_pressed() -> void:
	AnswerManager.add_answer.rpc_id(1, question.id, Utils.personal_id, answer_input.text)
