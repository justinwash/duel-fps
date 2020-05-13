extends "res://weapons/weapon.gd"

onready var raycast = $RayCast

func enter(weapon_handler):
	.enter(weapon_handler)
	
func update(weapon_handler, delta):
	.update(weapon_handler, delta)
	
func physics_update(weapon_handler, delta):
	.physics_update(weapon_handler, delta)
	
func on_input(weapon_handler, event):
	if cooldown >= COOLDOWN_TIME:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Rifle primary firing")
			weapon_handler.hud.anim.play("shoot")
			raycast.force_raycast_update()
			if raycast.is_colliding() and raycast.get_collider().get("player"):
				print("hit player ", raycast.get_collider().name, "!")
			cooldown = 0.0
			
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			print("Rifle secondary firing")
			weapon_handler.hud.anim.play("shoot")
			raycast.force_raycast_update()
			if raycast.is_colliding() and raycast.get_collider().get("player"):
				print("hit player ", raycast.get_collider().name, "!")
			cooldown = -COOLDOWN_TIME
	
func exit(weapon_handler):
	.exit(weapon_handler)
