extends Node

func enter(client):
	print('entered state: loading')
	client.switch_panel('loading')

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
