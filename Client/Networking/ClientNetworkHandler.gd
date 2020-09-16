extends Node

export(String) var SERVER_ADDRESS = 'localhost'
export(int) var SERVER_PORT = '3000'

export(NodePath) var DATASTORE
onready var datastore = get_node(DATASTORE)

onready var client = owner
onready var network_interface = owner.get_node('../NetworkInterface')

var connected = null
var initialized = false

func _ready():
	print('Connecting to server...')
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_ADDRESS, SERVER_PORT)
	get_tree().network_peer = peer
	
	if !initialized:
		var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
		var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
		var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")

func _process(_delta):
	if !initialized:
		initialized = true
	
func _connected_ok():
	connected = true
	print('Connected to server at ', SERVER_ADDRESS, ':', SERVER_PORT)
	
	if datastore && datastore.db:
		if datastore.db.player_info:
			send_data(1, 'player_info', 'register_player', datastore.db.player_info)
	
func _connected_fail():
	OS.alert('Failed to connect to server at ' + SERVER_ADDRESS + ':' + str(SERVER_PORT))
	get_tree().quit()
	
func _server_disconnected():
	connected = false
	
func send_data(target: int, type: String, command: String, data):
	network_interface.send_data(target, type, command, data)

func _on_Timer_timeout():
	if !connected:
		_ready()
