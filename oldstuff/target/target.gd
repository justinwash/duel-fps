extends KinematicBody

const MOVE_SPEED = 1
const RESPAWN_DELAY = 5

onready var raycast = $RayCast

var player = null
var dead = false

func _ready():
	add_to_group("targets")

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.kill()

func kill():
	dead = true
	$CollisionShape.disabled = true
	$Capsule.visible = false
	
	var timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.wait_time = RESPAWN_DELAY
	timer.start()
	
func set_player(p):
	player = p
	
func _on_timer_timeout():
	dead = false
	$CollisionShape.disabled = false
	$Capsule.visible = true
