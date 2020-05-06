extends KinematicBody

const MOVE_SPEED = 8
const MOUSE_SENS = 0.075
# const GRAVITY = -0.98

onready var raycast = $RayCast
onready var anim = $AnimationPlayer
onready var camera = $Camera

onready var hud = $HUD

func _ready():
	if (get_tree().has_network_peer() and !is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() == 0):
		for element in hud.get_children():
			element.visible = false
	
func _input(event):
	if (get_tree().has_network_peer() and is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() != 0):
		if event is InputEventMouseMotion:
			rotation_degrees.y -= MOUSE_SENS * event.relative.x
			rotation_degrees.x -= MOUSE_SENS * event.relative.y

func _physics_process(delta):
	if (get_tree().has_network_peer() and is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() != 0):
		$Camera.current = true
		var move_vec = Vector3()
		if Input.is_action_pressed("move_forwards"):
			move_vec.z -= 1
		if Input.is_action_pressed("move_backwards"):
			move_vec.z += 1
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1
			
		# move_vec.y = GRAVITY
		move_vec = move_vec.normalized()
		move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
		var _velocity = move_and_collide(move_vec * MOVE_SPEED * delta)
	
		if Input.is_action_just_pressed("shoot") and !anim.is_playing():
			anim.play("shoot")
			var coll = raycast.get_collider()
			if raycast.is_colliding() and coll.has_method("kill"):
				coll.kill()
		
		if get_tree().has_network_peer():
			rpc_unreliable("set_pos", global_transform)
		
puppet func set_pos(p_pos):
	global_transform = p_pos

func kill():
	print('hit target. do dmg')
