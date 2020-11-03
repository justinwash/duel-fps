extends Node

func enter(client):
	client.switch_panel('main_menu')
	client.panels['main_menu'].get_node("MatchmakingPanel").searching = false

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
