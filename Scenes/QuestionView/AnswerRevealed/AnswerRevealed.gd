extends QuestionBase

@onready var your_answer: Label = %YourAnswer
@onready var answer_mark_container: HBoxContainer = %AnswerMarkContainer

func _ready() -> void:
	if not question:
		return
	load_your_answer()
	load_answer_marking()

func load_your_answer():
	var answer = AnswerManager.get_answer(question.id, Utils.personal_id)
	
	if not answer:
		return
	
	if answer == "":
		your_answer.text = "Unanswered"
	
	your_answer.text = answer

func load_answer_marking():
	for answer in question.answers:
		var answer_mark = load("res://Scenes/QuestionView/AnswerRevealed/AnswerMark.tscn").instantiate()
		answer_mark.init(question, answer)
		answer_mark_container.add_child(answer_mark)
