extends Node

func enter(game):
	game.map = load("res://Shared/Scenes/Maps/" + game.map_to_load + '/' + game.map_to_load + '.tscn').instance()
	game.map_name = game.map.name
	game.add_child(game.map)
	
	game.change_state('spawn_players')

func ready(_game):
	pass
	
func update(_game, _delta):
	pass
	
func physics_update(_game, _delta):
	pass

func process_input(_game, _delta):
	pass

func exit(_game):
	pass
