extends Node

onready var clients = owner.clients

var games = []

func create_game(player_one, player_two):
	print('should start game between ', player_one, ' and ', player_two)
