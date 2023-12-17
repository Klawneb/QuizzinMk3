extends Control

@onready var question_container: BoxContainer = %QuestionContainer
@onready var answer_container: BoxContainer = %AnswerContainer
@onready var answer_list: VBoxContainer = $SidepanelContainer/Sidepanel/VBoxContainer/AnswerList
@onready var sidepanel_animations: AnimationPlayer = $SidepanelContainer/Sidepanel/SidepanelAnimations

var sidepanel_open: bool = false

var QuestionScenes = {
	Question.QuestionType.TEXT: "res://Scenes/QuestionView/QuestionText/QuestionText.tscn",
	Question.QuestionType.IMAGE: "res://Scenes/QuestionView/QuestionImage/QuestionImage.tscn",
	Question.QuestionType.AUDIO: "res://Scenes/QuestionView/QuestionAudio/QuestionAudio.tscn",
	Question.QuestionType.DRAWING: "res://Scenes/QuestionView/QuestionDrawing/QuestionDrawing.tscn",
	Question.QuestionType.ART: "res://Scenes/QuestionView/QuestionArt/QuestionArt.tscn",
	Question.QuestionType.DEATHMATCH: "res://Scenes/Deathmatch/DeathmatchLobby.tscn"
}

var AnswerScenes = {
	Question.AnswerType.TEXT: "res://Scenes/QuestionView/AnswerText/AnswerText.tscn"
}

func _ready() -> void:
	QuestionManager.question_load.connect(on_question_load)
	QuestionManager.answer_reveal.connect(on_answer_revealed)
	AnswerManager.answers_updated.connect(update_my_answers)
	
	update_my_answers()
	
func on_question_load(question: Question) -> void:
	Utils.remove_all_children(question_container)
	Utils.remove_all_children(answer_container)	
	QuestionManager.set_current_question(question)
	
	if question.question_type != Question.QuestionType.NONE:
		var question_node = load(QuestionScenes[question.question_type]).instantiate()
		question_node.init(question)
		question_container.add_child(question_node)
	
	if question.answer_type != Question.AnswerType.NONE:
		var answer_node = load(AnswerScenes[question.answer_type]).instantiate()
		answer_node.init(question)
		answer_container.add_child(answer_node)

func on_answer_revealed():
	Utils.remove_all_children(answer_container)
	
	var revealed_answer = load("res://Scenes/QuestionView/AnswerRevealed/AnswerRevealed.tscn").instantiate()
	revealed_answer.init(QuestionManager.current_question)
	answer_container.add_child(revealed_answer)

func update_my_answers():
	Utils.remove_all_children(answer_list)
	var question_num = 0
	for question_id in AnswerManager.answers:
		question_num += 1
		var answer_label = Label.new()
		var my_answer = AnswerManager.get_answer(question_id, Utils.personal_id)
		answer_label.text = str(question_num) + ". " + my_answer
		answer_list.add_child(answer_label)


func _on_texture_rect_pressed() -> void:
	if sidepanel_open:
		sidepanel_animations.play("close_sidepanel")
	else:
		sidepanel_animations.play("open_sidepanel")
	
	sidepanel_open = !sidepanel_open
