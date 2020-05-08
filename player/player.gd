extends KinematicBody

const GRAVITY = -20
const JUMP_SPEED = 7.5

const MAX_SPEED = 12
const ACCEL = 4.5

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var MOUSE_SENSITIVITY = 0.05

var dir = Vector3()
var vel = Vector3()

onready var camera = $RotationHelper/Camera
onready var rotation_helper = $RotationHelper
onready var anim = $AnimationPlayer
onready var raycast = $RotationHelper/RayCast
onready var hud = $HUD

var current_state
onready var states = {
	"idle": $States/Idle,
	"walk": $States/Walk,
	"jump": $States/Jump,
}

func _ready():
	if is_master_or_player(0):
		for element in hud.get_children():
			element.visible = false
			
	for child in get_children():
		child.connect("change_state", self, "_change_state")

	current_state = states.idle
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)

func _process(delta):
	if is_master_or_player(1):
		camera.current = true
		current_state.update(self, delta)
		
func _physics_process(delta):
	if is_master_or_player(1):
		current_state.physics_update(self, delta)
		
	if get_tree().has_network_peer():
		rpc_unreliable("set_pos", global_transform)

func _input(event):
	if is_master_or_player(1):
		current_state.on_input(self, event)

puppet func set_pos(p_pos):
	global_transform = p_pos

func kill():
	print('hit target. do dmg')
	
func is_master_or_player(id):
	if (get_tree().has_network_peer() and !is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() == id):
		return true
	else:
		return false
		
func _change_state(state_name):
	current_state.exit()
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
