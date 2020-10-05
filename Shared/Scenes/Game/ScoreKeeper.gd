extends Node

export(Array) var SCORES = [
	{ player = null, kills = 0, rounds_won = 0, game_won = false },
	{ player = null, kills = 0, rounds_won = 0, game_won = false },
]
export var CURRENT_ROUND = 1
var initialized = false

onready var players = get_node("../Players")

func initialize():
	for player in players.get_children():
		player.connect("died", self, "_increment_kill_score", [player])

func reset_kills():
	for score in SCORES:
		score.kills = 0

func reset_all():
	SCORES = [
	{ player = null, kills = 0, rounds_won = 0, game_won = false },
	{ player = null, kills = 0, rounds_won = 0, game_won = false },
]

func _increment_kill_score(killed_player):
	if killed_player.is_network_master():
		SCORES[1].kills += 1
		if SCORES[1].kills >= 2:
			SCORES[1].rounds_won += 1
			reset_kills()
			if SCORES[1].rounds_won >= 2:
				SCORES[1].game_won = true
				print(SCORES[1].player, ' won the game!')
				reset_all()
	else:
		SCORES[0].kills += 1
		if SCORES[0].kills  >= 2:
			SCORES[0].rounds_won += 1
			reset_kills()
			if SCORES[0].rounds_won >= 2:
				SCORES[0].game_won = true
				print(SCORES[0].player, ' won the game!')
				reset_all()
		
	print('KILL SCORE: ', 'Player 1 - ', SCORES[0].kills, ' | ', 'Player 2 - ', SCORES[1].kills)
	print('ROUND SCORE: ', 'Player 1 - ', SCORES[0].rounds_won, ' | ', 'Player 2 - ', SCORES[1].rounds_won)
