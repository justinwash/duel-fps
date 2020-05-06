extends Control

onready var status_ok = $StatusOk
onready var status_fail = $StatusFail
onready var find_button = $FindButton
onready var cancel_button = $CancelButton
onready var practice_button = $PracticeButton

signal start_matching
signal cancel_matching
signal toggle_connection
signal start_practice
signal leave_game

func _ready():	
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _connected_to_server = get_tree().connect("connected_to_server", self, "_connected_ok")
	var _connection_failed = get_tree().connect("connection_failed", self, "_connected_fail")
	var _server_disconnected = get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(_id):
	_set_status("Player joined: id " + str(_id), true)

func _player_disconnected(_id):
	_set_status("Player " + str(_id) + " disconnected", false)

func _connected_ok():
	_set_status("Connected", true)

func _connected_fail():
	_set_status("Couldn't connect", false)

func _server_disconnected():
	_set_status("Server disconnected", false)
	
func _set_matchmaking_server_status(status, isok):
	_set_status(status, isok)
	
func _set_status(text, isok):
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)

func _on_FindButton_pressed():
	emit_signal("start_matching")
	find_button.set_disabled(true)

func _on_CancelButton_pressed():
	if cancel_button.text == 'Cancel':
		emit_signal("cancel_matching")
	elif cancel_button.text == 'Leave Game':
		emit_signal("leave_game")
	find_button.set_disabled(false)
	practice_button.set_disabled(false)

func _on_ToggleConnectionButton_pressed():
	emit_signal("toggle_connection")

func _on_OfflineButton_pressed():
	emit_signal("leave_game")
	emit_signal("start_practice")
	practice_button.set_disabled(true)
