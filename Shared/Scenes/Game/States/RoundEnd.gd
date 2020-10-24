extends Node

onready var client = get_tree().get_root().get_node('Main/Client')

func enter(game):
	if !is_network_master():
		var round_end_panel = client.get_node("Panels/RoundEnd")
		print('game entered state: round_end')
		client.switch_panel('round_end')
		
		for player in game.players.get_children():
			if player.name == str(get_tree().get_network_unique_id()):
				var next_state
				if player.lives <= 0:
					var opponent = _get_opponent(game)
					if opponent.rounds_won >= 2:
						round_end_panel.result_label.text = 'DEFEAT'
						next_state = 'game_end'
					else:
						round_end_panel.result_label.text = 'ROUND LOST'
						next_state = 'weapon_select'
				elif player.rounds_won >= 2:
					round_end_panel.result_label.text = 'VICTORY'
					next_state = 'game_end'
				else:
					round_end_panel.result_label.text = 'ROUND WON'
					player.won_last_round = true
					next_state = 'weapon_select'
				
				round_end_panel.animation_player.disconnect('animation_finished', self, '_next_phase')
				round_end_panel.animation_player.connect('animation_finished', self, '_next_phase', [game, next_state])
				round_end_panel.play_anim()
				
				if get_tree().get_root().get_node("Main").MODE == 'CLIENT':
					var sync_data = {
						'type': 'reset_kills',
						'game_id': game.game_id,
						'player_id': game.local_player_id,
					}
					var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
					network_interface.send_data(1, 'client_server_sync', 'client_server_sync', sync_data)
					
	else:
		print('clients entered round_end. waiting for animations')
		
func _get_opponent(game):
	for player in game.players.get_children():
		if player.name != str(get_tree().get_network_unique_id()):
			return player
				
func _next_phase(_anim_name, game, next_state):
	game.change_state(next_state)
	
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
