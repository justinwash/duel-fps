extends Node

onready var players = $Players
onready var scorekeeper = $Scorekeeper

var map_name = 'No Map Loaded'
var map
var player_ids = []
var client_maps_loaded = false

var current_state
onready var states = {
	'load_map': $States/LoadMap,
}

func _ready():
	current_state = states.init
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
func _process(delta):
	current_state.update(self, delta)

func change_state(state_name):
	current_state.exit(self)
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
	if get_tree().get_root().get_node("Main").MODE == 'CLIENT':
		var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		network_interface.send_data(1, 'client_info', 'update_game_state', state_name)
	
func load_map(map_to_load):
	map = load("res://Shared/Scenes/Maps/" + map_to_load + '/' + map_to_load + '.tscn').instance()
	map_name = map.name
	add_child(map)
	
func server_spawn_players():
	if get_tree().get_root().get_node("Main").MODE == 'SERVER':
		var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		
		var current_spawn = 0
		for id in player_ids:
			var new_player = preload("res://Shared/Scenes/Player/Player.tscn").instance()
			new_player.set_name(str(id))
			
			# make spawn logic more robust later
			new_player.translation = map.spawns[current_spawn].translation
			current_spawn = current_spawn + 1

			new_player.set_network_master(id)
			players.add_child(new_player)
			print("spawned player for " + str(id) + ' on server.')

		if players.get_child_count() == 2:
			if scorekeeper and scorekeeper.has_method("initialize"):
				scorekeeper.initialize()
				
func client_spawn_players():
	pass
	
func set_client_map_loaded(_from_id, player_id):
	for player in players:
		if player.name == str(player_id):
			player.map_loaded = true
			

	

