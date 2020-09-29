extends Node

export(NodePath) var DATASTORE
onready var datastore = get_node(DATASTORE)

func setup_game(game_info):
	print('should setup game  at client with opponent', game_info)
	datastore.db['opponent_info'] = game_info
	print('loading default map')
	var new_game = preload("res://Shared/Scenes/Game/Game.tscn").instance()
	new_game.name = str(game_info.game_id)
	new_game.local_player_id = game_info.player_id
	if game_info.player_slot == 0:
		new_game.player_ids.append(game_info.player_id)
		new_game.player_ids.append(game_info.opponent_id)
	elif game_info.player_slot == 1:
		new_game.player_ids.append(game_info.opponent_id)
		new_game.player_ids.append(game_info.player_id)
	
	add_child(new_game)
	
	owner.change_state('in_game')
	
func end_game():
	print('Opponent disconnected. Exiting game. Bummer :(')
	for game in get_children():
		game.queue_free()
		
		owner.change_state('main_menu')
		datastore.db.erase('opponent_info')
		
func spawn_player(_from_id, player):
	if get_child(0):
		get_child(0).players.add_child(player)
	else:
		print('tried to spawn player for nonexistent game')
