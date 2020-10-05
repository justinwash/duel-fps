extends Spatial

var ROCKET_SPEED = 10
var ROCKET_DAMAGE = 15
var BLAST_STRENGTH = 20

var DEBOUNCE_TIME = 0.2

const KILL_TIMER = 4
var timer = 0

const Player = preload("res://Shared/Scenes/Player/Player.gd")

var hit_something = false
var shooter = null

func _ready():
	var _connect_rocket_area = $RocketArea.connect("body_entered", self, "collided")

func init(shotby):
	shooter = shotby

func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(-forward_dir * ROCKET_SPEED * delta)
	timer += delta

func collided(body):
	if timer > DEBOUNCE_TIME:
		print(shooter.name, "'s rocket collided with player ", body.name)
		if body is Player:
			if body != shooter:
				body.receive_hit(ROCKET_DAMAGE)
				queue_free()

		var blasted_bodies = $BlastRadius.get_overlapping_bodies()
		for blasted_body in blasted_bodies:
			print('rocket blasted: ', blasted_body.name)
			if blasted_body is Player:
				var d = blasted_body.translation - translation
				blasted_body.vel += (BLAST_STRENGTH / d.length()) * d
