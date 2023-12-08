extends Node

@onready var sounds = {
	"UI_Hover": AudioStreamPlayer.new(),
	"UI_Click": AudioStreamPlayer.new()
}

func _ready() -> void:
	sounds[&"UI_Click"].volume_db = -25
	sounds[&"UI_Hover"].volume_db = -20
	
	for i in sounds.keys():
		sounds[i].stream = load("res://Assets/Audio/SFX/" + str(i) + ".wav")
		sounds[i].max_polyphony = 10
		sounds[i].bus = &"Sound Effects"
		add_child(sounds[i])
