extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@export var animation_tree: AnimationTree
@export var locomotionBlendPath: String
@export var transitionSpeed: float = 10
@export var locomotionStatePlaybackPath: String

const SPEED = 5
const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = 10.0

var currentInput: Vector2
var currentVelocity: Vector2

func _enter_tree() -> void:
	SceneManager.right_click_menu_changed.emit(false)
	set_multiplayer_authority(str(name).to_int())

func _exit_tree() -> void:
	SceneManager.right_click_menu_changed.emit(true)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _ready() -> void:
	if not is_multiplayer_authority(): return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return

func _process(delta: float) -> void:
	var newDelta = currentInput - currentVelocity
	if (newDelta.length() > transitionSpeed * delta):
		newDelta = newDelta.normalized() * transitionSpeed * delta
	
	currentVelocity += newDelta
	
	animation_tree.set(locomotionBlendPath, currentVelocity)

func _input(event: InputEvent) -> void:
	if is_on_floor() && Input.is_action_just_pressed("ui_accept"):
		begin_jumping.rpc()
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	if !is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	currentInput = Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(currentInput.x, 0, currentInput.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

@rpc("any_peer", 'call_local')
func begin_jumping():
	var playback = animation_tree.get(locomotionStatePlaybackPath) as AnimationNodeStateMachinePlayback
	playback.travel("Jumping")
	velocity.y += JUMP_VELOCITY
	
