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

onready var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
onready var client = get_tree().get_root().get_node('Main/Client')

var game_id
var local_player_id
var opponent_id

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
	
	if is_network_master():
		camera.current = true
		model.visible = false
	else:
		camera.current = false
		model.visible = true

	if client:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	if is_network_master():
		camera.current = true
		current_state.update(self, delta)
		_move(delta)
		
		if Input.is_action_just_pressed("ui_cancel") && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.is_action_just_pressed("ui_cancel") && Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		
func _physics_process(delta):
	if is_network_master():
		current_state.physics_update(self, delta)
		var animation = model.get_node("AnimationPlayer").current_animation
		
		var sync_data = {
			'type': 'player_transform',
			'game_id': game_id,
			'player_id': local_player_id,
			'global_transform': global_transform,
			'visible': visible,
			'collision_layer': collision_layer,
			'collision_mask': collision_mask,
			'animation': animation
		}
		network_interface.send_data(1, 'client_server_sync', 'client_server_sync', sync_data)
		
func _input(event):
	if is_network_master():
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
		
func _start_round(weapons):
	var primary = weapons[0].instance()
	weapon_handler.primary_slot.add_child(primary)
	weapon_handler.weapons.primary = primary
		
	var secondary = weapons[1].instance()
	weapon_handler.secondary_slot.add_child(secondary)
	weapon_handler.weapons.secondary = secondary
	
	weapon_handler.on_ready()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func client_server_sync(sync_data):
	if !is_network_master():
		global_transform = sync_data.global_transform
		visible = sync_data.visible
		collision_layer = sync_data.collision_layer
		collision_mask = sync_data.collision_mask
		if !model.get_node("AnimationPlayer").current_animation == sync_data.animation:
			model.get_node("AnimationPlayer").play(sync_data.animation)
			
func server_client_sync(sync_data):
	if !is_network_master():
		global_transform = sync_data.global_transform
		visible = sync_data.visible
		collision_layer = sync_data.collision_layer
		collision_mask = sync_data.collision_mask
		if !model.get_node("AnimationPlayer").current_animation == sync_data.animation:
			model.get_node("AnimationPlayer").play(sync_data.animation)
