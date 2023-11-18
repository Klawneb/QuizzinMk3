extends Node

@onready var question_list: Array = load_question_list() as Array[Question]

signal question_load

func load_question_list() -> Array:
	var questions: Array = []
	var question_dir = DirAccess.open("res://Assets/Resources/Questions/")
	for file in question_dir.get_files():
		questions.append(load("res://Assets/Resources/Questions/" + file))
	
	return questions

#Broadcast the question to load to everyone
@rpc("authority", "call_local", "reliable")
func emit_load_question(question_dict: Dictionary):
	var question = dict_to_inst(question_dict) as Question
	question_load.emit(question)
