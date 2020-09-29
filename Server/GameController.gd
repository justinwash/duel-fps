extends Node

onready var clients = owner.clients
onready var network_interface = owner.network_interface

var games = []

func create_game(player_one, player_two):
	# does this solve the missing node issue?
	network_interface = owner.network_interface
	
	print('should start game between ', player_one, ' and ', player_two)
	print('sending game-start data to clients...')
	
	var new_game = preload("res://Shared/Scenes/Game/Game.tscn").instance()
	new_game.name = str(new_game.get_instance_id())
	new_game.player_ids = [player_one, player_two]
	add_child(new_game)
	
	var player_one_data = {
		game_id = new_game.get_instance_id(),
		opponent_id = player_two,
		client_info = clients[player_two]
	}
	clients[player_one].game_id = new_game.get_instance_id()
	clients[player_one].opponent_id = player_two
	network_interface.send_data(player_one, 'client_instruction', 'setup_game', player_one_data)
	
	var player_two_data = {
		game_id = new_game.get_instance_id(),
		opponent_id = player_one,
		client_info = clients[player_one]
	}
	clients[player_two].game_id = new_game.get_instance_id()
	clients[player_two].opponent_id = player_one
	network_interface.send_data(player_two, 'client_instruction', 'setup_game', player_two_data)
	
	
