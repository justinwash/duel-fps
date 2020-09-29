extends Node

onready var players = $Players
onready var scorekeeper = $Scorekeeper

var map_name = 'No Map Loaded'
var map_to_load = 'Test'
var map
var player_ids = []
var local_player_id
var client_maps_loaded = false

var current_state
onready var states = {
	'idle': $States/Idle,
	'load_map': $States/LoadMap,
	'spawn_players': $States/SpawnPlayers
}

func _ready():
	current_state = states.idle
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
	if get_tree().get_root().get_node("Main").MODE == 'CLIENT':
		var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		network_interface.send_data(1, 'client_info', 'update_game_state', 'idle')
	
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
			

	

