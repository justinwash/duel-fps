extends Node

func enter(game):
	var network_interface = get_tree().get_root().get_node("Main/NetworkInterface")
	var datastore = get_tree().get_root().get_node("Main/Client/DataStore")
		
	var current_spawn = 0
	for id in game.player_ids:
		var new_player = preload("res://Shared/Scenes/Player/Player.tscn").instance()
		new_player.set_name(str(id))
		new_player.local_player_id = id
		new_player.game_id = game.game_id
		new_player.opponent_id = game.player_ids[1] if current_spawn == 0 else game.player_ids[0]
			
		# make spawn logic more robust later
		new_player.translation = game.map.spawns.get_child(current_spawn).translation
		current_spawn = current_spawn + 1

		new_player.set_network_master(id)
		
		game.players.add_child(new_player)
		
		# move this somewhere else
		if get_tree().get_root().get_node("Main").MODE == 'CLIENT':
			if !is_network_master():
				var raw_model = new_player.model.get_child(0).get_child(0)
				for mesh in raw_model.get_children():
					if mesh.name != 'Head':
						mesh.get_surface_material(0).albedo_color = datastore.db['opponent_info'].client_info.player.color
		else:
			var raw_model = new_player.model.get_child(0).get_child(0)
			for mesh in raw_model.get_children():
				if mesh.name != 'Head':
					mesh.get_surface_material(0).albedo_color = get_tree().get_root().get_node("Main/Server").clients[id].player.color
				
		print("spawned player for " + str(id) + ' on server.')

	if game.players.get_child_count() == 2:
		if game.scorekeeper and game.scorekeeper.has_method("initialize"):
			game.scorekeeper.initialize()
		
		game.change_state('weapon_select')

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
