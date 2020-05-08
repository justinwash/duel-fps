extends Node

signal change_state

func enter(player):
	pass
	
func ready(player):
	pass # Replace with function body.
	
func update(player, delta):
	process_input(player, delta)
	
func physics_update(player, delta):
	process_movement(player, delta)
	
func on_input(player, event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player.rotation_helper.rotate_x(deg2rad(event.relative.y * player.MOUSE_SENSITIVITY * -1))
		player.rotate_y(deg2rad(event.relative.x * player.MOUSE_SENSITIVITY * -1))

		var camera_rot = player.rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		player.rotation_helper.rotation_degrees = camera_rot

func process_input(player, delta):
	# walking
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
			
	# shooting	
	if Input.is_action_just_pressed("shoot") and !player.anim.is_playing():
		player.anim.play("shoot")
		var coll = player.raycast.get_collider()
		if player.raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
			
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
