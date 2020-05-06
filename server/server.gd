extends Node

onready var udp = PacketPeerUDP.new()
onready var ping_tick = 0.0
onready var hosting_countdown = 0.0
onready var join_timeout = 0.0
onready var connected = false

var enet

onready var world = get_node('../../World')
onready var lobby = get_node('../../Lobby')

var new_match_data
var opponent_present = false

signal cancel_game

func _ready():
	_connect_networking_signals()
	_connect_world_signals()
	
func _process(delta):
	ping_tick += delta
	
	if udp.is_listening() && ping_tick > 0.5: # ping other player
		ping_tick -= 0.5
		udp.put_packet('ping!'.to_utf8())
		
	if udp.is_listening() && udp.get_available_packet_count() > 0:
			var response = udp.get_packet().get_string_from_utf8()

			if (response == "pong!"):
				udp.put_packet('ping!'.to_utf8())
			if (response == "ping!"):
				udp.put_packet('pong!'.to_utf8())
				if !connected:
					print('connection established')
				connected = true
			
	if udp.is_listening() && connected:
		hosting_countdown += delta
		if(hosting_countdown > 3.0):
			print("Closing socket, hosting...")
			udp.close()
			start_server(new_match_data)
			
	if (connected && !opponent_present) or !connected:
		join_timeout += delta
		if join_timeout > 25:
			_connected_fail()
			
	if enet && ping_tick > 0.5:
		enet.put_packet('ping!'.to_utf8())
	
func _connect_networking_signals():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connect_world_signals():
	var _map_loaded = world.connect("map_loaded", self, "_map_loaded")
	var _leave_match = connect("cancel_game", world, "_cancel_game")
	
func _connected_fail():
	get_tree().set_network_peer(null)
	udp.close()
	emit_signal("cancel_game")
	
func _player_connected(_id):
	print("player connected: ", _id)
	world.spawn_player(_id)
	world.spawn_player(get_tree().get_network_unique_id())
	
func _player_disconnected(_id):
	print("player disconnected: ", _id)
	emit_signal("cancel_game")
	lobby.show_lobby()
	
func connect_to_client(match_data):
	var ip = match_data.opponent.address
	if ip == match_data.player.address:
		ip = match_data.opponent.lanAddress
	if '::ffff:' in ip:
		ip = ip.substr(7) if ip.substr(7) != "::1" else get_node("../../Matchmaker").matchmaking_server_url.substr(7)
	if not ip.is_valid_ip_address():
		return
		
	match_data.opponent.address = ip
	new_match_data = match_data
		
	udp.listen(int(match_data.player.serverPort))
	udp.set_dest_address(new_match_data.opponent.address, int(match_data.opponent.serverPort))
	
func start_server(match_data):
	enet = NetworkedMultiplayerENet.new()
	enet.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = enet.create_server(int(match_data.player.serverPort), 1)
	if err != OK:
		print("Couldn't start server on port " + match_data.player.serverPort)
		return
	else:
		print("Server started on port " + match_data.player.serverPort)
	
	get_tree().set_network_peer(enet)
	
	# there should be another layer here for choosing map,
	# rules, etc
	world.load_map("test")
	
func _map_loaded():
	print('map loaded on server')
