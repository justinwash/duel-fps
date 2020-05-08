extends Node

signal change_state

func enter(player):
	print("entered state walk")
	
func ready(player):
	pass
	
func update(player, delta):
	process_input(player, delta)
	
func physics_update(player, delta):
	process_movement(player, delta)

func process_input(player, delta):
	if !(Input.is_action_pressed("move_forwards") or \
	Input.is_action_pressed("move_backwards") or \
	Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right")):
		player.change_state("idle")
# i hate this is there a better way?

	player.dir = Vector3()
	var cam_xform = player.camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("move_forwards"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("move_backwards"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1	

	input_movement_vector = input_movement_vector.normalized()

	player.dir += -cam_xform.basis.z * input_movement_vector.y
	player.dir += cam_xform.basis.x * input_movement_vector.x

	# jumping
	if player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			player.vel.y = player.JUMP_SPEED
			
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
