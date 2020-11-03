extends Node

func enter(client):
	var weapon_select_panel = client.panels['weapon_select']
	
	client.switch_panel('weapon_select')

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
