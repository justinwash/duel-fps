extends Node

func enter(player):
#	for element in player.hud.get_children():
#			if element.get("visible"):
#				element.visible = false
				
	player.round_start_ui.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	
func ready(_player):
	pass
	
func update(player, _delta):
	pass
	
func physics_update(_player, _delta):
	pass

func process_input(_player, _delta):
	pass

func exit(player):
	for element in player.hud.get_children():
			if element.get("visible"):
				element.visible = true
