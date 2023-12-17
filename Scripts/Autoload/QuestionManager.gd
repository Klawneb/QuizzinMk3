extends Node

@onready var question_list: Array = load_question_list() as Array[Question]

signal question_load
signal answer_reveal
signal current_question_updated
signal audio_played
signal audio_stopped
signal prompt_received
signal question_list_updated

var current_question: Question

func load_question_list() -> Array:
	var questions: Array = []
	var question_dir = DirAccess.open("res://Assets/Resources/Questions/")
	for file in question_dir.get_files():
		if file.ends_with(".remap"):
			file = file.trim_suffix(".remap")
		
		questions.append(load("res://Assets/Resources/Questions/" + file))
	
	return questions

@rpc('any_peer', 'call_local', 'reliable')
func add_art_question(artist: String, line_data: Array, prompt: String, canvas_color: Color, id: String) -> void:
	if question_exists(id):
		remove_question_id(id)
	var question = ArtQuestion.new()
	question.artist = artist
	question.line_data = line_data
	question.answers.append(prompt)
	question.question_type = question.QuestionType.ART
	question.answer_type = question.AnswerType.TEXT
	question.id = id
	question.main_text = artist + "'s drawing"
	question.canvas_color = canvas_color
	question_list.append(question)
	question_list_updated.emit()

func question_exists(id: String):
	for question in question_list:
		if question.id == id:
			return true
	return false

func remove_question_id(id: String):
	for question in question_list:
		if question.id == id:
			question_list.erase(question)

#Broadcast the question to load to everyone
@rpc("authority", "call_local", "reliable")
func emit_load_question(question_dict: Dictionary):
	var question = dict_to_inst(question_dict) as Question
	question_load.emit(question)

@rpc("authority", "call_local", "reliable")
func emit_reveal_answer():
	answer_reveal.emit()

func set_current_question(question: Question):
	current_question = question
	current_question_updated.emit()

@rpc("authority", "call_local", "reliable")
func emit_audio_played():
	audio_played.emit()

@rpc("authority", "call_local", "reliable")
func emit_audio_stopped():
	audio_stopped.emit()
	
@rpc("authority", "call_local", "reliable")
func emit_prompt(prompt: String):
	prompt_received.emit(prompt)
	
@rpc("authority", "call_local", "reliable")
func distribute_prompts(prompts: Array[String]):
	var p = prompts.duplicate()
	for multiplayer_id in multiplayer.get_peers():
		var selected_prompt = p.pick_random()
		p.erase(selected_prompt)
		emit_prompt.rpc_id(multiplayer_id, selected_prompt)
