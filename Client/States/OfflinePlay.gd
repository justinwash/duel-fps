extends Node

func enter(client):
	print('entered state: practice')
	client.switch_panel(null)
	
	client.game_controller.setup_game({})

func ready(_client):
	pass
	
func update(_client, _delta):
	pass
	
func physics_update(_client, _delta):
	pass

func process_input(_client, _delta):
	pass

func exit(_client):
	pass
