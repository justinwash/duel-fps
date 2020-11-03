extends Node

export var CURRENT_ROUND = 1
var initialized = false

onready var players = get_node("../Players")
onready var game = owner

func initialize():
	for player in players.get_children():
		player.connect("died", self, "decrement_lives_outgoing", [player])
		player.lives = 2
		player.rounds_won = 0
		player.game_won = false

func reset_kills():
	for player in players.get_children():
		player.lives = 2

func reset_all():
	for player in players.get_children():
		player.lives = 2
		player.rounds_won = 0
		player.game_won = false
	
# Sync scores methods
func decrement_lives_internal(killed_player_id):
	players.get_node(killed_player_id).lives -= 1
			
	if players.get_node(killed_player_id).lives <= 0:
		for player in players.get_children():
			if player.name != killed_player_id:
				player.rounds_won += 1
				if player.rounds_won >= 2:
					player.game_won = true
	
func decrement_lives_outgoing(killed_player):
	if killed_player.name == str(game.local_player_id):
		var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		var sync_data = {
			'type': 'decrement_lives',
			'game_id': game.game_id,
			'player_id': game.local_player_id,
			'killed_player_id': killed_player.name,
			'amount': 1
		}
		network_interface.send_data(1, 'client_server_sync', 'client_server_sync', sync_data)
	
func sync_scores_incoming(scores):
	pass
# Sync scores methods
