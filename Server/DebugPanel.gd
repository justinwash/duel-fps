extends Control

onready var server = owner
onready var player_info_box = $PlayerInfoBox
onready var queue_info_box = $QueueInfoBox

func _process(_delta):
	player_info_box.clear()
	for client in server.clients:
		player_info_box.add_item('id: ' + str(client) + '    info: ' + str(server.clients[client].player) + '    state: ' + server.clients[client].state)
	queue_info_box.clear()
	for player in server.matchmaking_controller.queue:
		queue_info_box.add_item('id: ' + str(player) + '    name: ' + server.clients[player].player.name)
