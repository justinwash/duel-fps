extends Spatial

var ROCKET_SPEED = 10
var ROCKET_DAMAGE = 15

const KILL_TIMER = 4
var timer = 0

const Player = preload("../../player/player.gd")

var hit_something = false
var shooter = null

func _ready():
	$Area.connect("body_entered", self, "collided")

func init(shotby):
	shooter = shotby

func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(-forward_dir * ROCKET_SPEED * delta)

func collided(body):
	if body is Player:
		if body != shooter:
			print(shooter.name, "'s rocket collided with player ", body.name)
			body.rocket_hit(ROCKET_DAMAGE, translation)
			queue_free()

	
	# if hit_something == false:
	# 	if body.has_method("bullet_hit"):
	# 		body.bullet_hit(ROCKET_DAMAGE, global_transform)

	# hit_something = true
	# queue_free()
