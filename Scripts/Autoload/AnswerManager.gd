extends Node

var answers = {}

signal answers_updated

@rpc("any_peer", "call_remote", "reliable")
func add_answer(question_id: String, personal_id: String, answer: String):
	if not answers.has(question_id):
		answers[question_id] = {}
	
	answers[question_id][personal_id] = answer
	answers_updated.emit()
	
	if is_multiplayer_authority():
		add_answer.rpc_id(multiplayer.get_remote_sender_id(), question_id, personal_id, answer)
