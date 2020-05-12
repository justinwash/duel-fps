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
onready var raycast = $RotationHelper/RayCast
onready var hud = $HUD
onready var weapon_handler = $WeaponHandler

var current_state
onready var states = {
	"idle": $States/Idle,
	"walk": $States/Walk,
	"jump": $States/Jump,
}

func _ready():
	if !is_master_or_player(1):
		for element in hud.get_children():
			if element.get("visible"):
				element.visible = false
			
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
		
		_move(delta)
		
		if get_tree().has_network_peer():
			rpc_unreliable("set_pos", global_transform)

func _input(event):
	if is_master_or_player(1):
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

			var camera_rot = rotation_helper.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -70, 70)
			rotation_helper.rotation_degrees = camera_rot

func _move(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY * 1.1

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	
puppet func set_pos(p_pos):
	global_transform = p_pos
	
func is_master_or_player(id):
	if (get_tree().has_network_peer() and is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() == id):
		return true
	else:
		return false
		
func change_state(state_name):
	current_state.exit()
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
