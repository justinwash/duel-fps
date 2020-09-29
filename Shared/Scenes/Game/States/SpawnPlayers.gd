extends Node

func enter(game):
	var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
		
	var current_spawn = 0
	for id in game.player_ids:
		var new_player = preload("res://Shared/Scenes/Player/Player.tscn").instance()
		new_player.set_name(str(id))
			
			# make spawn logic more robust later
		new_player.translation = game.map.spawns.get_child(current_spawn).translation
		current_spawn = current_spawn + 1

		new_player.set_network_master(id)
		
		game.players.add_child(new_player)
		print("spawned player for " + str(id) + ' on server.')

	if game.players.get_child_count() == 2:
		if game.scorekeeper and game.scorekeeper.has_method("initialize"):
			game.scorekeeper.initialize()

func ready(_game):
	pass
	
func update(_game, _delta):
	pass
	
func physics_update(_game, _delta):
	pass

func process_input(_game, _delta):
	pass

func exit(_game):
	pass
