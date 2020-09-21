extends Node

export(int) var PORT = 3000
export(int) var MAX_PLAYERS = 1024

onready var player_controller = $PlayerController
onready var matchmaking_controller = $MatchmakingController
onready var game_controller = $GameController

onready var network_interface = get_node("../NetworkInterface")

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
	if clients[id].has('game_id'):
		var game_id = clients[id]['game_id']
		var game = game_controller.get_node(str(game_id))
		if game:
			game.queue_free()
	if clients[id].has('opponent_id'):
		var opponent_id = clients[id]['opponent_id']
		network_interface.send_data(opponent_id, 'client_instruction', 'end_game', null)
		
	var _removed_client = clients.erase(id)
	print('Client ', id, ' disconnected.')
	
func update_client_state(id, state):
	clients[id].state = state
