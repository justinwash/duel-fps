extends Node

export(String) var SERVER_ADDRESS = 'localhost'
export(int) var SERVER_PORT = '3000'

onready var client = owner
onready var network_interface = owner.get_node('../NetworkInterface')

var connected = null
var initialized = false

func _ready():
	print('Connecting to server...')
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_ADDRESS, SERVER_PORT)
	get_tree().network_peer = peer
	
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _process(_delta):
	if !initialized:
		initialized = true
		client.change_state("connecting_to_server")
	
func _connected_ok():
	connected = true
	print('Connected to server at ', SERVER_ADDRESS, ':', SERVER_PORT)
	
func _connected_fail():
	OS.alert('Failed to connect to server at ' + SERVER_ADDRESS + ':' + str(SERVER_PORT))
	get_tree().quit()
	
func _server_disconnected():
	connected = false
	OS.alert('Server disconnected. Handle this more gracefully in the future...')
	get_tree().quit()
	
func send_data(target, type, data):
	network_interface.send_data(target, type, data)
