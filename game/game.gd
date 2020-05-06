extends Node

onready var matchmaker = $Matchmaker
onready var lobby = $Lobby
onready var networking_mode = $NetworkingMode
onready var world = $World

# relay signals, for bridging communication between child nodes
signal map_loaded
signal start_matching
signal cancel_matching
signal toggle_connection
signal set_matchmaking_server_status
signal left_game

func _ready():
	_connect_matchmaking_signals()
	_connect_world_signals()

func _connect_matchmaking_signals():
	matchmaker.connect("start_game", self, "_start_game")
	matchmaker.connect("leave_game", self, "leave_game")
	matchmaker.connect("set_matchmaking_server_status", self, "_set_matchmaking_server_status")
	
func _connect_world_signals():
	world.connect("map_loaded", self, "_map_loaded")
	
func _start_game(match_data):
	if match_data.player.host:
		var server = load("res://server/server.tscn").instance()
		networking_mode.add_child(server)
		server.connect_to_client(match_data)
	elif match_data.opponent.host:
		var client = load("res://client/client.tscn").instance()
		networking_mode.add_child(client)
		client.connect_to_server(match_data)
	else:
		print("invalid networking mode")
		
# relay functions: these simply move signals from one child to another
func _map_loaded():
	emit_signal("map_loaded")
	
func _start_matching():
	emit_signal("start_matching")
	
func _cancel_matching():
	emit_signal("cancel_matching")
	
func _toggle_connection():
	emit_signal("toggle_connection")

func _start_practice():
	world.load_map("test")
	world.spawn_player(1)
	world.spawn_player(0)
	
func leave_game():
	get_tree().network_peer = null
	for node in world.players.get_children():
		node.queue_free()
	for node in world.get_children():
		if node.name != 'Players':
			node.queue_free()
	for node in networking_mode.get_children():
		node.queue_free()
	
	emit_signal("left_game")
	
func cancel_game():
	get_tree().network_peer = null
	for node in world.players.get_children():
		node.queue_free()
	for node in world.get_children():
		if node.name != 'Players':
			node.queue_free()
	for node in networking_mode.get_children():
		node.queue_free()
	
	emit_signal("left_game")
	_set_matchmaking_server_status("Match canceled or timed out.", false)
	
func _set_matchmaking_server_status(status, isok):
	emit_signal("set_matchmaking_server_status", status, isok)
