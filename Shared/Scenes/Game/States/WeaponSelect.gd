extends Node

onready var client = get_tree().get_root().get_node('Main/Client')

func enter(game):
	if !is_network_master():
		var weapon_select_panel = client.get_node("Panels/WeaponSelect")
		client.switch_panel('weapon_select')
		for player in game.players.get_children():
			if player.name == str(get_tree().get_network_unique_id()):
				weapon_select_panel.connect("start_round", player, "_start_round")
				weapon_select_panel.won_last_round = player.won_last_round
				weapon_select_panel.reset()
				weapon_select_panel.start_timer()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func ready(_game):
	pass
	
func update(_game, _delta):
	pass
	
func physics_update(_game, _delta):
	pass

func process_input(_game, _delta):
	pass

func exit(_game):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
