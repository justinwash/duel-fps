extends Node

signal change_state

func enter(player):
	print("entered state idle")
	
func ready(player):
	pass
	
func update(player, delta):
	if Input.is_action_pressed("move_forwards") or \
	Input.is_action_pressed("move_backwards") or \
	Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right"):
		player.change_state("walk")
	
func physics_update(player, delta):
	process_movement(player, delta)

func process_input(player, delta):
	pass
			
func process_movement(player, delta):
	player.dir.y = 0
	player.dir = player.dir.normalized()

	player.vel.y += delta * player.GRAVITY * 1.1

	var hvel = player.vel
	hvel.y = 0

	var target = player.dir
	target *= player.MAX_SPEED

	var accel
	if player.dir.dot(hvel) > 0:
		accel = player.ACCEL
	else:
		accel = player.DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	player.vel.x = hvel.x
	player.vel.z = hvel.z
	player.vel = player.move_and_slide(player.vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(player.MAX_SLOPE_ANGLE))

func exit():
	pass
