extends Node

var ROUND_SCORE = [0,0]
var KILL_SCORE = [0,0]
var initialized = false

onready var players = get_node("../Players")

func initialize():
	for player in players.get_children():
		player.connect("died", self, "_increment_kill_score", [player])

func reset():
	KILL_SCORE = [0,0]

func _increment_kill_score(killed_player):
	if killed_player.is_master_or_player(1):
		KILL_SCORE[1] += 1
		if KILL_SCORE[1] >= 2:
			ROUND_SCORE[1] += 1
			reset()
			for player in players.get_children():
				player.change_state("roundend")
	else:
		KILL_SCORE[0] += 1
		if KILL_SCORE[0] >= 2:
			ROUND_SCORE[0] += 1
			reset()
			for player in players.get_children():
				player.change_state("roundend")
		
	print('KILL SCORE: ', 'Player 1 - ', KILL_SCORE[0], ' | ', 'Player 2 - ', KILL_SCORE[1])
	print('ROUND SCORE: ', 'Player 1 - ', ROUND_SCORE[0], ' | ', 'Player 2 - ', ROUND_SCORE[1])
