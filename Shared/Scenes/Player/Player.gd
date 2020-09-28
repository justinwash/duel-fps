extends KinematicBody

var player = true
var round_ready = false

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
onready var weapon_handler = $RotationHelper/WeaponHandler
onready var status = $Status
onready var anim = $AnimationPlayer
onready var timer = $Timer
onready var model = $RotationHelper/Model

var current_state
onready var states = {
	"idle": $States/Idle,
	"walk": $States/Walk,
	"jump": $States/Jump,
	"dead": $States/Dead
}

signal died

func _ready():
	status.connect("health_updated", self, "health_updated")
	
	current_state = states.idle
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
	if get_tree().get_root().get_node("Main").MODE == 'CLIENT':
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
		camera.current = true
		current_state.update(self, delta)
		_move(delta)
		
		if Input.is_action_just_pressed("ui_cancel") && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.is_action_just_pressed("ui_cancel") && Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		
func _physics_process(delta):

	current_state.physics_update(self, delta)
		
	var animation = model.get_node("AnimationPlayer").current_animation
	#rpc_unreliable("set_pos", global_transform, visible, collision_layer, collision_mask, animation)
		
func _input(event):
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
	
puppet func set_pos(p_pos, is_visible, col_layer, col_mask, animation):
	global_transform = p_pos
	visible = is_visible
	collision_layer = col_layer
	collision_mask = col_mask
	if !model.get_node("AnimationPlayer").current_animation == animation:
		model.get_node("AnimationPlayer").play(animation)
	
master func receive_hit(amount):
	status.HEALTH -= amount
		
func change_state(state_name):
	current_state.exit(self)
	model.get_node("AnimationPlayer").play("idle")
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
func health_updated():
	if status.HEALTH <= 0 and current_state != states.dead:
		change_state("dead")