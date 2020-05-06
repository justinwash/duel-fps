extends Control

const DEFAULT_PORT = 42069

onready var address = $Address
onready var host_button = $HostButton
onready var join_button = $JoinButton
onready var status_ok = $StatusOk
onready var status_fail = $StatusFail

func _ready():
	if !owner.online or owner.matchmaking:
		host_button.set_disabled(true)
		join_button.set_disabled(true)
		_set_status("Offline or Matchmaking", false)
		return
		
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(_id):
	_set_status("Player joined: id " + str(_id), true)

func _player_disconnected(_id):
	host_button.set_disabled(false)
	join_button.set_disabled(false)
	
	_set_status("Player " + str(_id) + " disconnected", false)

func _connected_ok():
	_set_status("Connected", true)

func _connected_fail():
	_set_status("Couldn't connect", false)
	
	get_tree().set_network_peer(null)
	
	host_button.set_disabled(false)
	join_button.set_disabled(false)

func _server_disconnected():
	_set_status("Server disconnected", false)

func _set_status(text, isok):
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)

func _on_host_pressed():
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(DEFAULT_PORT, 1)
	if err != OK:
		_set_status("Can't host, address in use.",false)
		return
	else:
		print("Server started on port " + str(DEFAULT_PORT))
	
	get_tree().set_network_peer(host)
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	_set_status("Waiting for player...", true)

func _on_join_pressed():
	var ip = address.get_text()
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid", false)
		return
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)
	
	_set_status("Connecting...", true)
