extends Node

onready var spawns = get_tree().get_root().get_node("Game/World/Map/Spawns")

func enter(player):
	print("player ", player, " is kill")
	player.anim.play("die")
	player.timer.wait_time = 5
	player.timer.connect("timeout", self, "respawn", [player])
	player.timer.start()
	
func ready(_player):
	pass
	
func update(player, _delta):
	pass
	
func physics_update(_player, _delta):
	pass

func process_input(_player, _delta):
	pass

func exit():
	pass
	
func respawn(player):
	print("player ", player.name, " should respawn")
	player.timer.disconnect("timeout", self, "respawn")
	
	player.status.HEALTH = 100
	player.global_transform = spawns.get_child(randi() % spawns.get_child_count()).global_transform
	player.anim.play("spawn")
