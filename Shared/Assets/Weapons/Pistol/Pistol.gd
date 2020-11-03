extends "res://Shared/Assets/Weapons/Weapon.gd"

func enter(weapon_handler):
	.enter(weapon_handler)
	
func update(weapon_handler, delta):
	.update(weapon_handler, delta)
	
func physics_update(weapon_handler, delta):
	.physics_update(weapon_handler, delta)
	
func on_input(weapon_handler, event):
	if cooldown >= current_cooldown:
		if event.button_index == BUTTON_LEFT and event.pressed:
			weapon_handler.hud.anim.play("shoot")
			raycast.force_raycast_update()
			
			var target = get_raycast_collider()
			if target and target.get("player"):
				
				if get_tree().has_network_peer():
					target.rpc("receive_hit", PRIMARY_DAMAGE)
				else:
					target.receive_hit(PRIMARY_DAMAGE)
					
			cooldown = 0.0
			current_cooldown = PRIMARY_COOLDOWN_TIME
			
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			weapon_handler.hud.anim.play("shoot")
			raycast.force_raycast_update()
			
			var target = get_raycast_collider()
			if target and target.get("player"):
				
				if get_tree().has_network_peer():
					target.rpc("receive_hit", PRIMARY_DAMAGE)
				else:
					target.receive_hit(PRIMARY_DAMAGE)
					
			cooldown = 0.0
			current_cooldown = SECONDARY_COOLDOWN_TIME
		
func exit(weapon_handler):
	.exit(weapon_handler)
