extends "res://weapons/weapon.gd"

var projectile = preload("res://weapons/rocket/projectile.tscn")

func enter(weapon_handler):
	.enter(weapon_handler)
	
func update(weapon_handler, delta):
	.update(weapon_handler, delta)
	
func physics_update(weapon_handler, delta):
	.physics_update(weapon_handler, delta)
	
func on_input(weapon_handler, event):
	if cooldown >= current_cooldown:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var rocket = projectile.instance()
			rocket.init(weapon_handler.player)
			var scene_root = get_tree().root.get_children()[0]
			scene_root.add_child(rocket)
			rocket.global_transform = weapon_handler.get_parent().global_transform
			
			cooldown = 0.0
			current_cooldown = PRIMARY_COOLDOWN_TIME
	
func exit(weapon_handler):
	.exit(weapon_handler)
