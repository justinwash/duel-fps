extends Control

onready var server = owner
onready var player_info_box = $PlayerInfoBox

func _process(_delta):
	player_info_box.clear()
	for client in server.clients:
		player_info_box.add_item('id: ' + str(client) + '    info: ' + str(server.clients[client].player) + '    state: ' + server.clients[client].state)
