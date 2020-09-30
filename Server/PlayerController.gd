extends Node

onready var clients = owner.clients

func register_player(id, player_info):
	clients[id].player = player_info
	
	print('registered new player: id: ', id, ' info: ', player_info)
