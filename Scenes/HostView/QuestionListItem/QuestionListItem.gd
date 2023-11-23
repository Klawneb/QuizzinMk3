extends PanelContainer

@onready var question_text: Label = %QuestionText
@onready var submit_button: Button = %SubmitButton

var question: Question

func _ready() -> void:
	QuestionManager.current_question_updated.connect(on_current_question_updated)
	
	question_text.text = question.main_text

func init(question: Question):
	self.question = question

func _on_submit_button_pressed() -> void:
	QuestionManager.emit_load_question.rpc(inst_to_dict(question))

func on_current_question_updated() -> void:
	if QuestionManager.current_question.id == question.id:
		var stylebox := StyleBoxFlat.new()
		self.add_theme_stylebox_override("panel", stylebox)
	else:
		self.remove_theme_stylebox_override("panel")
