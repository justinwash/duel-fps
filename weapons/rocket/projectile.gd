extends Spatial

var ROCKET_SPEED = 10
var ROCKET_DAMAGE = 15

const KILL_TIMER = 4
var timer = 0

var hit_something = false

func _ready():
	pass
	#$Area.connect("body_entered", self, "collided")

func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(-forward_dir * ROCKET_SPEED * delta)

func collided(body):
	pass
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(ROCKET_DAMAGE, global_transform)

	hit_something = true
	queue_free()
