extends "res://weapons/weapon.gd"

func enter(weapon_handler):
	.enter(weapon_handler)
	
func update(weapon_handler, delta):
	.update(weapon_handler, delta)
	
func physics_update(weapon_handler, delta):
	.physics_update(weapon_handler, delta)
	
func on_input(weapon_handler, event):
	if cooldown >= current_cooldown:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Pistol primary firing")
			weapon_handler.hud.anim.play("shoot")
			raycast.force_raycast_update()
			
			var target = get_raycast_collider()
			if target and target.get("player"):
				print("hit player ", target.name, "!")
				
				if get_tree().has_network_peer():
					rpc("receive_hit", PRIMARY_DAMAGE)
				else:
					target.receive_hit(PRIMARY_DAMAGE)
					
			cooldown = 0.0
			current_cooldown = PRIMARY_COOLDOWN_TIME
			
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			print("Pistol secondary firing")
			weapon_handler.hud.anim.play("shoot")
			raycast.force_raycast_update()
			
			var target = get_raycast_collider()
			if target and target.get("player"):
				print("hit player ", target.name, "!")
				
				if get_tree().has_network_peer():
					rpc("receive_hit", PRIMARY_DAMAGE)
				else:
					target.receive_hit(PRIMARY_DAMAGE)
					
			cooldown = 0.0
			current_cooldown = SECONDARY_COOLDOWN_TIME
		
func exit(weapon_handler):
	.exit(weapon_handler)
