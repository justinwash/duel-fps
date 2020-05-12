extends Spatial

var crosshair = load("res://weapons/pistol/crosshair.svg")
var icon = load("res://weapons/pistol/icon.svg")

export var COOLDOWN_TIME = 0.5
var cooldown = 0.0

func enter(_weapon_handler):
	pass 
	
func update(_weapon_handler, delta):
	cooldown += delta
	
func physics_update(weapon_handler, _delta):
	if cooldown > 0.0:
		weapon_handler.hud.reload_indicator.value = (cooldown / COOLDOWN_TIME) * 100
	else:
		weapon_handler.hud.reload_indicator.value = 0
	
func on_input(weapon_handler, event):
	if cooldown >= COOLDOWN_TIME:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Pistol primary firing")
			weapon_handler.hud.anim.play("shoot")
			
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			print("Pistol secondary firing")
			weapon_handler.hud.anim.play("shoot")
			
		cooldown = 0.0
	
func exit(_weapon_handler):
	pass
