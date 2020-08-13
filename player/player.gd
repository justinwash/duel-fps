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
onready var round_start_ui = $Overlay/RoundStartUI
onready var round_end_ui = $Overlay/RoundEndUI
onready var model = $RotationHelper/Model

var current_state
onready var states = {
	"idle": $States/Idle,
	"walk": $States/Walk,
	"jump": $States/Jump,
	"dead": $States/Dead,
	"picking": $States/Picking,
	"roundend": $States/RoundEnd
}

signal ready_up
signal died

func _ready():
	status.connect("health_updated", self, "health_updated")

	round_start_ui.connect("start_round", self, "_start_round")
	
	if !is_master_or_player(1):
		for element in hud.get_children():
			if element.get("visible"):
				element.visible = false
	else:
		model.visible = false
			
	current_state = states.picking
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)

func _start_round(weapons):
	var primary = weapons[0].instance()
	weapon_handler.primary_slot.add_child(primary)
	weapon_handler.weapons.primary = primary
		
	var secondary = weapons[1].instance()
	weapon_handler.secondary_slot.add_child(secondary)
	weapon_handler.weapons.secondary = secondary
	
	weapon_handler.on_ready()
	
	round_start_ui.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if is_master_or_player(1):
		set_ready(true)
		rpc("set_ready", true)
	else:
		set_ready(true)
	
func _process(delta):
	if is_master_or_player(1):
		camera.current = true
		current_state.update(self, delta)
		_move(delta)
	# make dummy react to gravity
	elif is_master_or_player(0):
		if !round_ready:
			set_ready(true)
			
		_move(delta)
		
func _physics_process(delta):
	if is_master_or_player(1):
		current_state.physics_update(self, delta)
		
		if get_tree().has_network_peer():
			var animation = model.get_node("AnimationPlayer").current_animation
			rpc_unreliable("set_pos", global_transform, visible, collision_layer, collision_mask, animation)
			
	if Input.is_action_pressed("pause") && is_master_or_player(1):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			for element in hud.get_children():
				if element.get("visible") != null:
					element.visible = true
		else:
			for element in hud.get_children():
				if element.get("visible") != null:
					element.visible = false
		
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
	
puppet func set_pos(p_pos, is_visible, col_layer, col_mask, animation):
	global_transform = p_pos
	visible = is_visible
	collision_layer = col_layer
	collision_mask = col_mask
	if !model.get_node("AnimationPlayer").current_animation == animation:
		model.get_node("AnimationPlayer").play(animation)
	
puppet func set_ready(is_ready):
	round_ready = is_ready
	emit_signal("ready_up", self)
	
master func receive_hit(amount):
	status.HEALTH -= amount
	
func is_master_or_player(id):
	if (get_tree().has_network_peer() and is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() == id):
		return true
	else:
		return false
		
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
