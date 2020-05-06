extends Node

onready var lobby = get_node('../Lobby')
onready var matchmaker = get_node('../Matchmaker')

onready var server = $Server
onready var client = $Client

func _ready():
	_connect_matchmaking_signals()
	
func _connect_matchmaking_signals():
	matchmaker.connect("start_game", self, "_set_networking_mode")
	
func _set_networking_mode(data):
	print('setting networking mode to ' + data.networking_mode)
	
	if data.networking_mode == 'server':
		server.start_server()
	else:
		client.start_client(data.server_address)
