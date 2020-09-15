extends Node

func enter(client):
	print('entered state: main menu')
	client.switch_panel('main_menu')

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
