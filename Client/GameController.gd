extends Node

export(NodePath) var DATASTORE
onready var datastore = get_node(DATASTORE)

func start_game(opponent_info):
	print('should start game  at client with opponent', opponent_info)
	datastore.db['opponent_info'] = opponent_info
	
	var new_game = preload("res://Shared/Scenes/Game/Game.tscn").instance()
	new_game.name = str(opponent_info.game_id)
	add_child(new_game)
	
	owner.change_state('in_game')
	
func end_game():
	print('Opponent disconnected. Exiting game. Bummer :(')
	for game in get_children():
		game.queue_free()
		
		owner.change_state('main_menu')
		datastore.db.erase('opponent_info')
		
func spawn_player(_from_id, player):
	get_child(0).players.add_child(player)
	
