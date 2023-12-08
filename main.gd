extends Node

@onready var debug_menu: Window = $DebugMenu
@onready var user_list: RichTextLabel = $DebugMenu/TabContainer/UserList
@onready var answer_list: RichTextLabel = $DebugMenu/TabContainer/AnswerList
@onready var settings_menu: Control = $SettingsMenu
@onready var tooltip: PanelContainer = $Tooltip
@onready var tooltip_label: RichTextLabel = $Tooltip/TooltipLabel
@onready var tooltips = preload("res://Assets/Data/tooltip_text.gd").tooltips
@onready var video_stream_player: VideoStreamPlayer = $Tooltip/VideoStreamPlayer

var tooltip_index = 0

func _ready() -> void:
	UserManager.user_list_updated.connect(update_user_list)
	AnswerManager.answers_updated.connect(update_answer_list)
	SceneManager.settings_opened.connect(settings_menu.show_settings)
	update_user_list()
	update_answer_list()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_mouse"):
		tooltip.visible = true
		tooltip.position = event.position + Vector2(0, 20)
		tooltip_label.text = tooltips[tooltip_index]
		tooltip_index += 1
		tooltip.size.y = tooltip_label.get_content_height()
		tooltip.size.x = 200
		
		if tooltip_index == 71:
			video_stream_player.visible = true
			video_stream_player.play()
		else:
			video_stream_player.visible = false
			video_stream_player.stop()
		
		if tooltip_index > tooltips.size() - 1:
			tooltip_index = 0
	
	if Input.is_action_just_pressed("left_mouse"):
		tooltip.visible = false
		video_stream_player.visible = false
		video_stream_player.stop()

func _on_debug_button_pressed() -> void:
	debug_menu.visible = !debug_menu.visible

func update_user_list():
	user_list.text = var_to_str(UserManager.user_list)

func update_answer_list():
	answer_list.text = var_to_str(AnswerManager.answers)
