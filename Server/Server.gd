extends Node

export(int) var PORT = 3000
export(int) var MAX_PLAYERS = 1024

const players = {}
	
func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	
	var _network_peer_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _network_peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	print('Server running on port: ', PORT)
	
func _player_connected(id):
	players[id] = 'awaiting info'
	print('Player ', id, ' connected.')
	
remote func register_player(player_info):
	var id = get_tree().get_rpc_sender_id()
	players[id] = player_info
	
	print('registered new player: id: ', id, ' info: ', player_info)
	
func _player_disconnected(id):
	var _removed_player = players.erase(id)
	print('Player ', id, ' disconnected.')
