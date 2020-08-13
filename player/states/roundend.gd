extends Node

func enter(player):
	player.round_start_ui.visible = false
	player.round_end_ui.visible = true
	player.round_end_ui._start_timer()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	
	for element in player.hud.get_children():
			if element.get("visible"):
				element.visible = false
	
func ready(_player):
	pass
	
func update(_player, _delta):
	pass
	
func physics_update(_player, _delta):
	pass

func process_input(_player, _delta):
	pass

func exit(player):
	player.round_end_ui.visible = false
	for element in player.hud.get_children():
			if element.get("visible"):
				element.visible = true
