extends Node

onready var panels = get_node("../../Panels")

func enter(player):
	print("entered state startround")

func ready(_player):
	panels.switch_panel("startround")
	
func update(player, _delta):
	pass
	
func physics_update(_player, _delta):
	pass

func process_input(_player, _delta):
	pass

func exit(_player):
	pass
