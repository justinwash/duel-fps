extends Node

onready var players = $Players
onready var scorekeeper = $Scorekeeper

var map_name = 'No Map Loaded'
var map_to_load = 'Test'
var map
var player_ids = []
var local_player_id
var game_id
var client_maps_loaded = false

var current_state
onready var states = {
	'idle': $States/Idle,
	'load_map': $States/LoadMap,
	'spawn_players': $States/SpawnPlayers,
	'weapon_select': $States/WeaponSelect
}

func _ready():
	current_state = states.idle
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
	if get_tree().get_root().get_node("Main").MODE == 'CLIENT':
		var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		network_interface.send_data(1, 'client_info', 'update_game_state', 'idle')
		get_tree().get_root().get_node("Main/Client").game_id = game_id
	
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
			
func client_server_sync(sync_data):
	match (sync_data.type):
		'player_transform':
			for player in players.get_children():
				if player.name == str(sync_data.player_id):
					player.sync_transform_incoming(sync_data)
				else:
					server_client_sync(int(player.name), sync_data)
		'player_ready_state':
			for player in players.get_children():
				if player.name == str(sync_data.player_id):
					player.set_ready_state(sync_data.ready_state)
					print(player.name, ' ready state ', sync_data.ready_state)
				server_client_sync(int(player.name), sync_data)
		'player_weapon_selection':
			for player in players.get_children():
				if player.name == str(sync_data.player_id):
					player.sync_weapon_selection_incoming(sync_data.weapons)
					print(player.name, ' selected_weapons ', sync_data.weapons)
				else:
					server_client_sync(int(player.name), sync_data)
			
					
func server_client_sync(target_id, sync_data):
	if is_network_master():
		var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		if network_interface:
			network_interface.send_data(target_id, 'server_client_sync', 'server_client_sync', sync_data)
	else:
		match (sync_data.type):
			'player_transform':
				for player in players.get_children():
					if player.name == str(sync_data.player_id):
						player.sync_transform_incoming(sync_data)
			'player_ready_state':
				var player_nodes = players.get_children()
				var player_ready_states = [false, false]
				var i = 0
				for player in player_nodes:
					if player.name == str(sync_data.player_id):
						player.set_ready_state(sync_data.ready_state)
					player_ready_states[i] = true if player.weapons_selected else false
					i += 1
				if player_ready_states[0] and player_ready_states[1]:
					for player in player_nodes:
						player.skip_timer()
				print(str(player_ready_states))
			'player_weapon_selection':
				for player in players.get_children():
					if player.name == str(sync_data.player_id):
						player.sync_weapon_selection_incoming(sync_data.weapons)
