extends Camera3D

@onready var fps_rig: Node3D = $fps_rig
@onready var ray_cast_3d: RayCast3D = $fps_rig/RayCast3D
@onready var animation_tree: AnimationTree = $fps_rig/AnimationTree
@onready var fire: AudioStreamPlayer3D = $gun_sounds/Fire
@onready var empty_fire: AudioStreamPlayer3D = $gun_sounds/Empty_fire
@onready var ammo_count: Label = $AmmoCount
@onready var skeleton_3d: Skeleton3D = $fps_rig/Skeleton3D
@onready var animation_player: AnimationPlayer = $fps_rig/AnimationPlayer
@onready var reload_player: AudioStreamPlayer3D = $gun_sounds/Reload

var recoil_dampening = 1
var ammo = 30

var firing = false
var aiming = false
var reloading = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fps_rig.position.x = lerp(fps_rig.position.x, 0., delta*5)
	fps_rig.position.y = lerp(fps_rig.position.y, 0., delta*5)
	fps_rig.position.z = lerp(fps_rig.position.z, 0., delta*5)
	fps_rig.rotation.x = lerp(fps_rig.rotation.x, 0., delta*5)
	fps_rig.rotation.y = lerp(fps_rig.rotation.y, 0., delta*5)
	fps_rig.rotation.z = lerp(fps_rig.rotation.z, 0., delta*5)
	pass

func directional_sway(sway_amount: Vector2):	
	fps_rig.position.x -= sway_amount.x*0.0002
	fps_rig.position.y += sway_amount.y*0.0002

func movement_sway(sway_amount: Vector2):
	if !aiming:
		fps_rig.position.z -= sway_amount.y*0.002
		fps_rig.position.x -= sway_amount.x*0.002

func shoot():	
	if !firing and !reloading:
		firing = true		
		
		if ammo > 0:
			shoot_audio()
			if ray_cast_3d.is_colliding():
				var hit_player = ray_cast_3d.get_collider()
				hit_player.receive_damage.rpc_id(hit_player.get_multiplayer_authority(), 20)
			
			fps_rig.position.x += randf_range(-.5, .5) * 0.02 * recoil_dampening
			fps_rig.position.y += randf_range(0, .75) * 0.02 * recoil_dampening
			fps_rig.position.z += 1.5 * 0.02 * recoil_dampening	
			fps_rig.rotation.x += .75 * 0.02 * recoil_dampening
			ammo -= 1
			ammo_count.text = str(ammo) + "/30"
		else:
			empty_fire.pitch_scale = randf_range(0.9, 1.1)
			empty_fire.play()
		
		await get_tree().create_timer(0.1).timeout
		firing = false


func shoot_audio():
	fire.pitch_scale = randf_range(.8, 1.2)
	fire.play()

func start_aiming():
	print("aiming")
	aiming = true
	var playback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	playback.travel("aiming")
	recoil_dampening = 0.2

func stop_aiming():
	aiming = false
	var playback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	playback.travel("idle")
	recoil_dampening = 1

func reload():
	reload_player.play()
	reloading = true	
	var playback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	playback.travel("reload")
	ammo = 30
	ammo_count.text = str(ammo) + "/30"

func reload_ended():
	reloading = false
