extends Node

var answers = {}

signal answers_updated

@rpc("any_peer", "call_remote", "reliable")
func add_answer(question_id: String, personal_id: String, answer: String) -> void:
	if not answers.has(question_id):
		answers[question_id] = {}
		
	if not answers[question_id].has(personal_id):
		answers[question_id][personal_id] = {
			"score": 0
		}
	
	answers[question_id][personal_id]["text"] = answer
	answers_updated.emit()
	
	if is_multiplayer_authority():
		add_answer.rpc_id(multiplayer.get_remote_sender_id(), question_id, personal_id, answer)

func get_answer(question_id: String, personal_id: String) -> String:
	if answer_exists(question_id, personal_id):
		return answers[question_id][personal_id].text
	
	return ""

func get_answer_score(question_id: String, personal_id: String) -> int:
	if answer_exists(question_id, personal_id):
		return answers[question_id][personal_id].score
	
	return 0

func answer_exists(question_id: String, personal_id: String):
	if answers.has(question_id):
		if answers[question_id].has(personal_id):
			return true
	
	return false

@rpc("any_peer", "call_remote", "reliable")
func increase_answer_score(question_id: String, personal_id: String, score: int):
	if answer_exists(question_id, personal_id):
		answers[question_id][personal_id].score += score
	answers_updated.emit()
	
	if is_multiplayer_authority():
		increase_answer_score.rpc_id(multiplayer.get_remote_sender_id(), question_id, personal_id, score)
