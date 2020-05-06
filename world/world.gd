extends Node

onready var players = $Players

var map

signal map_loaded

func _ready():
	pass
	
func load_map(map_name):
	map = load("res://maps/" + map_name + '/' + map_name + '.tscn').instance()
	map.name = "Map"
	add_child(map)
	emit_signal("map_loaded")
	
func spawn_player(_id):
	var new_player = preload("res://player/player.tscn").instance()
	new_player.set_name(str(_id))
	
	if _id == 1:
		new_player.translation = map.spawns.get_node("1").translation
	else:
		new_player.translation = map.spawns.get_node("2").translation
		
	new_player.set_network_master(_id)
	players.add_child(new_player)
	print("spawned player for " + str(_id))
	
func _leave_game():
	if get_parent().has_method("leave_game"):
		get_parent().leave_game()

func _cancel_game():
	if get_parent().has_method("cancel_game"):
		get_parent().cancel_game()
		
