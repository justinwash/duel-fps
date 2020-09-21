extends Node

onready var panels = get_node("../../Panels")

func enter(game):
	print("entered state startround")
	
func ready(game):
	var players = game.world.players.get_children()
	for player in players:
		panels.get_node("RoundStart").connect("start_round", player, "_start_round")
	
	panels.switch_panel("roundstart")
	panels.get_node("RoundStart").start_timer()
	
func update(game, _delta):
	pass
	
func physics_update(_game, _delta):
	pass

func process_input(_game, _delta):
	pass

func exit(_game):
	pass
