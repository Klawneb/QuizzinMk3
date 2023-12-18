extends CharacterBody3D

@onready var camera: Camera3D = $Head/Camera3D
@export var animation_tree: AnimationTree
@export var transitionSpeed: float = 10
@export var locomotionBlendPath: String
@export var sprintingBlendPath: String
@export var locomotionStatePlaybackPath: String
@export var aimingBlendPath: String
@export var aiming: bool = false
@onready var spine_ik_target: Marker3D = $Head/Camera3D/SpineIKTarget
@onready var player_model: Node3D = $PlayerModel
@onready var spine_ik: SkeletonIK3D = $PlayerModel/Node/Skeleton3D/SpineIK
@onready var head: Node3D = $Head
@onready var footstep_player: AudioStreamPlayer3D = $PlayerAudio/FootstepPlayer
@onready var footstep_raycast: RayCast3D = $Head/FootstepRaycast
@onready var speed_label: Label = $speed_label
@onready var name_label: Label3D = $Username
@onready var view_model_camera: Camera3D = $Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera
@onready var bullet_impact_player: AudioStreamPlayer3D = $PlayerAudio/BulletImpactPlayer
@onready var damage_vignette: ColorRect = $Head/Camera3D/DamageVignette

const WALK_SPEED = 5
const JUMP_VELOCITY = 5
const SPRINT_SPEED = 7.5
const BASE_FOV = 90
const FOV_CHANGE = 1

var jumpQueued: bool
var t_bob = 0.0
var gravity: float = 10.0
var currentInput: Vector2
var currentVelocity: Vector2
var aimBlendAmount: float = 0
var footstepPlayed = false
var bob_amp = 0.04
var bob_frequency = 4.0
var speed = WALK_SPEED
var bhop_speed = 0
var bhop_reducer = 0
var sprinting = false
var username: String = ""
var health: float = 100

func _enter_tree() -> void:
	SceneManager.right_click_menu_changed.emit(false)
	set_multiplayer_authority(str(name).to_int())

func _exit_tree() -> void:
	SceneManager.right_click_menu_changed.emit(true)
	SceneManager.global_mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	SceneManager.respawn_player.connect(respawn)
	
	name_label.text = username
	spine_ik.start()
	
	if not is_multiplayer_authority(): return
	
	$Head/Camera3D/SubViewportContainer/SubViewport.size = DisplayServer.window_get_size()
	$Head/Camera3D/SubViewportContainer.visible = true
	view_model_camera.visible = true
	
	name_label.visible = false
	player_model.visible = false	
	SceneManager.global_mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return

func _process(delta: float) -> void:
	var newDelta = currentInput - currentVelocity
	if (newDelta.length() > transitionSpeed * delta):
		newDelta = newDelta.normalized() * transitionSpeed * delta
	
	currentVelocity += newDelta
	
	if aiming:
		aimBlendAmount = lerp(aimBlendAmount, 0.95, delta * 10)
	else:
		aimBlendAmount = lerp(aimBlendAmount, 0., delta * 10)
	animation_tree.set(locomotionBlendPath, currentVelocity)
	animation_tree.set(sprintingBlendPath, currentVelocity)	
	animation_tree.set(aimingBlendPath, aimBlendAmount)
	
	view_model_camera.movement_sway(currentVelocity)	

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		begin_jumping.rpc()
		
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		view_model_camera.directional_sway(Vector2(event.relative.x, event.relative.y))
	
	if Input.is_action_just_pressed("right_mouse"):
		aiming = true
		view_model_camera.start_aiming()
	if Input.is_action_just_released("right_mouse"):
		aiming = false
		view_model_camera.stop_aiming()
	
	if Input.is_action_just_pressed("reload"):
		view_model_camera.reload()

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if Input.is_action_pressed("left_mouse"):
		view_model_camera.shoot()
	
	$Head/Camera3D/SubViewportContainer/SubViewport/ViewModelCamera.global_transform = camera.global_transform
	damage_vignette.material.set_shader_parameter("vignette_opacity", 1 - health/100)	
	
	if !is_on_floor():
		bhop_reducer = 0
		velocity.y -= gravity * delta
		jumpQueued = false
	
	if jumpQueued:
		velocity.y = JUMP_VELOCITY
		bhop_speed += 0.5
		jumpQueued = false
	
	var total_speed = speed + bhop_speed
	speed_label.text = "speed: " + str(total_speed)

	currentInput = Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(currentInput.x, 0, currentInput.y)).normalized()
	if is_on_floor():
		bhop_reducer += 0.0025
		bhop_speed -= lerp(0., float(bhop_speed), bhop_reducer)
		if direction:
			velocity.x = direction.x * total_speed
			velocity.z = direction.z * total_speed
		else:
			velocity.x = lerp(velocity.x, direction.x * total_speed, delta * 8)
			velocity.z = lerp(velocity.z, direction.z * total_speed, delta * 8)
	else:
		velocity.x = lerp(velocity.x, direction.x * total_speed, delta * 3)
		velocity.z = lerp(velocity.z, direction.z * total_speed, delta * 3)
	
	
	if Input.is_action_pressed("sprint"):
		if is_on_floor():
			if currentInput.y < 0:
					speed = SPRINT_SPEED
			else:
				speed = WALK_SPEED
	else:
		speed = WALK_SPEED
	
	if Input.is_action_just_pressed("sprint"):
		begin_sprinting.rpc()
	
	if Input.is_action_just_released("sprint"):
		begin_locomotion.rpc()
	
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 10)
	
	if currentInput.x > 0:
		head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(-2.5), 0.05)
	elif currentInput.x < 0:
		head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(2.5), 0.05)
	else:
		head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(0), 0.05)

	t_bob += delta * velocity.length() * float(is_on_floor())
	var headbob_vector = headbob(t_bob)
	camera.transform.origin = headbob_vector
	footstep_raycast.transform.origin = headbob_vector
	
	if footstep_raycast.is_colliding() and !footstepPlayed:
		footstep_player.pitch_scale = randf_range(2, 3)
		play_footstep.rpc()
		footstepPlayed = true
	elif not footstep_raycast.is_colliding():
		footstepPlayed = false
	
	move_and_slide()
	
@rpc("any_peer", 'call_local', "unreliable")
func begin_sprinting():
	var playback = animation_tree.get(locomotionStatePlaybackPath) as AnimationNodeStateMachinePlayback
	animation_tree.set("parameters/StateMachine/conditions/is_sprinting", true)	
	playback.travel("Sprinting")

@rpc("any_peer", 'call_local', "unreliable")
func begin_locomotion():
	var playback = animation_tree.get(locomotionStatePlaybackPath) as AnimationNodeStateMachinePlayback
	animation_tree.set("parameters/StateMachine/conditions/is_sprinting", false)
	playback.travel("Locomotion")

@rpc("any_peer", 'call_local', "unreliable")
func begin_jumping():
	var playback = animation_tree.get(locomotionStatePlaybackPath) as AnimationNodeStateMachinePlayback
	playback.travel("Jumping")

func execute_jump():
	jumpQueued = true

func headbob(time: float):
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_frequency) * bob_amp
	pos.x = cos(time * bob_frequency / 2) * bob_amp
	return pos

@rpc("any_peer", "call_local", "unreliable")
func play_footstep():
	footstep_player.play()

@rpc("any_peer")
func receive_damage(damage: int):
	health -= damage
	bullet_impact_player.pitch_scale = randf_range(0.8, 1.2)
	bullet_impact_player.play()
	if health <= 0:
		health = 100
		SceneManager.player_died.emit()

func respawn(spawn_position: Vector3):
	position = spawn_position
