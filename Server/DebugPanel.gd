extends Control

onready var server = owner
onready var player_info_box = $PlayerInfoBox

func _process(_delta):
	player_info_box.clear()
	for player in server.players:
		player_info_box.add_item('id: ' + str(player) + '    info: ' + str(server.players[player]))
