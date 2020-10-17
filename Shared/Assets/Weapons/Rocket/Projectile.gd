extends Spatial

var ROCKET_SPEED = 15
var ROCKET_DAMAGE = 15
var BLAST_STRENGTH = 40

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
	if body != shooter:
		$RocketArea/CollisionShape.disabled = true
	
	if timer > DEBOUNCE_TIME:
		var blasted_bodies = $BlastRadius.get_overlapping_bodies()
		
		if body is Player:
			if body != shooter:
				print(shooter.name, "'s rocket collided with player ", body.name)
				if get_tree().has_network_peer():
					body.rpc("receive_hit", ROCKET_DAMAGE)
				else:
					body.receive_hit(ROCKET_DAMAGE)
					
				for blasted_body in blasted_bodies:
					if blasted_body is Player:
						var d = global_transform.basis.z.normalized()
						blasted_body.rpc("apply_push", ((BLAST_STRENGTH) * -d))

		else:
			for blasted_body in blasted_bodies:
				if blasted_body is Player:
					print(shooter.name, "'s splash radius collided with player ", body.name)
					var d = blasted_body.translation - translation
					if get_tree().has_network_peer():
						body.rpc("receive_hit", int(ROCKET_DAMAGE / d.length()))
						print('splash damage: ', int(ROCKET_DAMAGE / d.length()))
					else:
						body.receive_hit(int(ROCKET_DAMAGE / d.length()))
		
			for blasted_body in blasted_bodies:
				if blasted_body is Player:
					var d = blasted_body.translation - translation
					blasted_body.rpc("apply_push", ((BLAST_STRENGTH / d.length()) / 2 * d))
		
		queue_free()
