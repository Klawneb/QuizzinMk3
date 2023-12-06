extends PanelContainer

@onready var username_label: Label = $HBoxContainer/Username
@onready var answer_label: Label = $HBoxContainer/Answer
@onready var score_label: Label = $HBoxContainer/Score


var username: String
var answer: String
var score: int

func _ready() -> void:
	username_label.text = username
	answer_label.text = answer
	score_label.text = str(score)

func init(username: String, answer: String, score: int) -> void:
	self.username = username
	self.answer = answer
	self.score = score
