extends Node

onready var client = get_tree().get_root().get_node('Main/Client')

func enter(game):
	if !is_network_master():
		var game_end_panel = client.get_node("Panels/GameEnd")
		client.switch_panel('game_end')
		
		for player in game.players.get_children():
			if player.name == str(get_tree().get_network_unique_id()):
				if player.rounds_won >= 2:
					game_end_panel.result_label.text = 'VICTORY'
				else:
					game_end_panel.result_label.text = 'DEFEAT'
				
				if get_tree().get_root().get_node("Main").MODE == 'CLIENT':
					var sync_data = {
						'type': 'game_end',
						'game_id': game.game_id,
						'player_id': game.local_player_id,
					}
					var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
					network_interface.send_data(1, 'game_end', 'game_end', sync_data)
		
func _get_opponent(game):
	for player in game.players.get_children():
		if player.name != str(get_tree().get_network_unique_id()):
			return player
	
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
