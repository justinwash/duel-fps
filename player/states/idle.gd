extends Node

func enter(player):
	print("entered state idle")
	player.model.get_node("AnimationPlayer").play("idle")
	
	for element in player.hud.get_children():
			if element.get("visible"):
				element.visible = true
	
func ready(_player):
	pass
	
func update(player, _delta):
	if Input.is_action_just_pressed("jump"):
		player.change_state("jump")
		
	if Input.is_action_pressed("move_forwards") or \
	Input.is_action_pressed("move_backwards") or \
	Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right"):
		player.change_state("walk")
	
	else: 
		player.dir = Vector3(0,0,0)
	
func physics_update(_player, _delta):
	pass

func process_input(_player, _delta):
	pass

func exit(_player):
	pass
