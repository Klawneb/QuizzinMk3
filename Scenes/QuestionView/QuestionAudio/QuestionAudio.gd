extends QuestionBase

@onready var main_text: Label = $VBoxContainer/VBoxContainer/MainText
@onready var audio_stream_player: AudioStreamPlayer = $VBoxContainer/VBoxContainer2/VBoxContainer/AudioStreamPlayer
@onready var player_controls: HBoxContainer = $VBoxContainer/VBoxContainer2/VBoxContainer/PlayerControls
@onready var song_progress: ProgressBar = $VBoxContainer/VBoxContainer2/VBoxContainer/SongProgress

func _ready() -> void:
	QuestionManager.audio_played.connect(on_audio_played)
	QuestionManager.audio_stopped.connect(on_audio_stopped)
	
	main_text.text = question.main_text
	var audio: AudioStream = load(question.audio_path)
	audio_stream_player.stream = audio
	
	song_progress.max_value = audio.get_length()
	
	if is_multiplayer_authority():
		player_controls.visible = true

func _process(delta: float) -> void:
	song_progress.value = audio_stream_player.get_playback_position()

func on_audio_played():
	audio_stream_player.play()

func on_audio_stopped():
	audio_stream_player.stop()

func _on_play_button_pressed() -> void:
	QuestionManager.emit_audio_played.rpc()

func _on_stop_button_pressed() -> void:
	QuestionManager.emit_audio_stopped.rpc()

func _on_volume_slider_value_changed(value: float) -> void:
	audio_stream_player.volume_db = value
