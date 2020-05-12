extends Spatial

export (Texture) var crosshair = load("res://weapons/crosshairs/crosshair.svg")
export (Texture) var icon = load("res://weapons/icons/001-gun.svg")

export var COOLDOWN_TIME = 0.5
export var SWITCH_DELAY = 0.2
var cooldown = 0.0

func enter(weapon_handler):
	cooldown = COOLDOWN_TIME - SWITCH_DELAY
	weapon_handler.hud.anim.play("shoot")
	weapon_handler.hud.weapon_crosshair.set_texture(crosshair)
	weapon_handler.hud.weapon_icon.set_texture(icon)
	
func update(weapon_handler, delta):
	cooldown += delta
	if cooldown >= COOLDOWN_TIME:
		if Input.is_action_pressed("select_primary_weapon"):
			weapon_handler.select_weapon("primary")
		elif Input.is_action_pressed("select_secondary_weapon"):
			weapon_handler.select_weapon("secondary")
		elif Input.is_action_just_pressed("toggle_weapon"):
			weapon_handler.toggle_weapon()
		elif Input.is_action_just_released("toggle_weapon_wheel"):
			weapon_handler.toggle_weapon()
	
func physics_update(weapon_handler, _delta):
	if cooldown > 0.0:
		weapon_handler.hud.reload_indicator.value = (cooldown / COOLDOWN_TIME) * 100
	else:
		weapon_handler.hud.reload_indicator.value = 0
		
func on_input(_weapon_handler, _event):
	pass
	
func exit(_weapon_handler):
	pass
