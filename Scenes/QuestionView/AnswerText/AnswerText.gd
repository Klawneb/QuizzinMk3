extends QuestionBase

@onready var answer_input: LineEdit = $InputContainer/AnswerInput
@onready var input_container: HBoxContainer = $InputContainer
@onready var existing_answer_container: HBoxContainer = $ExistingAnswerContainer
@onready var your_answer: Label = $ExistingAnswerContainer/VBoxContainer/YourAnswer


func _ready() -> void:
	AnswerManager.answers_updated.connect(update_existing_answer)
	
	if AnswerManager.get_answer(question.id, Utils.personal_id) == "":
		if not is_multiplayer_authority():
			AnswerManager.add_answer.rpc_id(1, question.id, Utils.personal_id, "")
	
	update_existing_answer()

func _on_submit_button_pressed() -> void:
	AnswerManager.add_answer.rpc_id(1, question.id, Utils.personal_id, answer_input.text)
	set_existing_visible(true)

func _on_edit_button_pressed() -> void:
	set_existing_visible(false)

func set_existing_visible(is_visible: bool):
	input_container.visible = !is_visible
	existing_answer_container.visible = is_visible

func update_existing_answer():
	var existing_answer = AnswerManager.get_answer(question.id, Utils.personal_id)
	if existing_answer != "":
		your_answer.text = existing_answer
		set_existing_visible(true)
