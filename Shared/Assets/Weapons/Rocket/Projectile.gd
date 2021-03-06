extends Spatial

var ROCKET_SPEED = 15
var ROCKET_DAMAGE = 15
var BLAST_STRENGTH = 40

var DEBOUNCE_TIME = 0.0

const KILL_TIMER = 4
var timer = 0

const Player = preload("res://Shared/Scenes/Player/Player.gd")
const Dummy = preload("res://Shared/Scenes/Dummy/Dummy.gd")

var hit_something = false
var shooter = null

onready var smooth = $Smooth3D
func _ready():
	var _connect_rocket_area = $Smooth3D/MeshInstance/RocketArea.connect("body_entered", self, "collided")

func init(shotby):
	shooter = shotby

func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(-forward_dir * ROCKET_SPEED * delta)
	timer += delta

func collided(body):
	if body != shooter:
		$Smooth3D/MeshInstance/RocketArea/CollisionShape.disabled = true
	else:
		return
	
	if timer > DEBOUNCE_TIME:
		var blasted_bodies = $Smooth3D/MeshInstance/BlastRadius.get_overlapping_bodies()
		
		if body is Player || body is Dummy:
			if body != shooter:
				if get_tree().has_network_peer():
					body.rpc("receive_hit", ROCKET_DAMAGE)
				else:
					body.receive_hit(ROCKET_DAMAGE)
					
				for blasted_body in blasted_bodies:
					if blasted_body is Player:
						var d = global_transform.basis.z.normalized()
						blasted_body.rpc("apply_push", ((BLAST_STRENGTH) * -d))
					if blasted_body is Dummy:
						var d = global_transform.basis.z.normalized()
						blasted_body.apply_push((BLAST_STRENGTH) * -d)

		else:
			for blasted_body in blasted_bodies:
				if blasted_body is Player:
					var d = blasted_body.translation - translation
					if get_tree().has_network_peer():
						body.rpc("receive_hit", int(ROCKET_DAMAGE / d.length()))
					else:
						body.receive_hit(int(ROCKET_DAMAGE / d.length()))
		
			for blasted_body in blasted_bodies:
				if blasted_body is Player:
					var d = blasted_body.translation - translation
					blasted_body.rpc("apply_push", ((BLAST_STRENGTH / d.length()) / 2 * d))
				if blasted_body is Dummy:
					var d = global_transform.basis.z.normalized()
					blasted_body.apply_push((BLAST_STRENGTH) * -d)
		
		queue_free()
