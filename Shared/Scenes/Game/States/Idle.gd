extends Node

func enter(game):
	print('game entered state: idle')
	
	game.change_state('load_map')

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