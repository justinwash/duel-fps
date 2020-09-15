extends Node

export(int) var PORT = 3000
export(int) var MAX_PLAYERS = 1024

const clients = {}
	
func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	
	var _network_peer_connected = get_tree().connect("network_peer_connected", self, "_client_connected")
	var _network_peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_client_disconnected")
	
	print('Server running on port: ', PORT)
	
func _client_connected(id):
	clients[id] = {
		state = 'connecting_to_server',
		player = {}
	}
	print('Client ', id, ' connected.')
	
func _client_disconnected(id):
	var _removed_client = clients.erase(id)
	print('Client ', id, ' disconnected.')
	
func update_client_state(id, state):
	clients[id].state = state
