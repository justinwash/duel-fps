extends Node

onready var players = $Players
onready var scorekeeper = $Scorekeeper

var map_name = 'No Map Loaded'
var player_ids = []

signal map_loaded

func _ready():
	load_map('Test')
	
func load_map(map_to_load):
	var map = load("res://Shared/Scenes/Maps/" + map_to_load + '/' + map_to_load + '.tscn').instance()
	map_name = map.name
	add_child(map)
	emit_signal("map_loaded")
	
	server_spawn_players()
	
func server_spawn_players():
	if get_tree().get_root().get_node("Main").MODE == 'SERVER':
		var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		for id in player_ids:
			var new_player = preload("res://Shared/Scenes/Player/Player.tscn").instance()
			new_player.set_name(str(id))
			
			# handle spawn logic later
			# new_player.translation = spawn_point.translation

			new_player.set_network_master(id)
			players.add_child(new_player)
			print("spawned player for " + str(id) + ' on server.')
			
			for target_id in player_ids:
				network_interface.send_data(target_id, 'game_instruction', 'spawn_player', new_player)

		if players.get_child_count() == 2:
			if scorekeeper and scorekeeper.has_method("initialize"):
				scorekeeper.initialize()

