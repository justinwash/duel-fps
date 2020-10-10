extends Panel

onready var equipped_weapons = $EquippedWeapons

onready var slots = [$Slot1, $Slot2]

func add_equipped_weapon(weapon_button):
	if len(equipped_weapons.get_children()) < 2:
		var new_equipped_weapon = weapon_button.duplicate()
		equipped_weapons.add_child(new_equipped_weapon)
		
		place_equipped_weapons()

func remove_equipped_weapon(weapon_button):
	if len(equipped_weapons.get_children()) > 0:
		for weapon in equipped_weapons.get_children():
			if weapon_button.name == weapon.name:
				weapon.free()
		
		place_equipped_weapons()

func place_equipped_weapons():
	if len(equipped_weapons.get_children()) > 0:
		var i = 0
		for weapon in equipped_weapons.get_children():
			weapon.rect_global_position = slots[i].rect_global_position
			weapon.slot_label.text = 'Q' if i == 0 else 'E'
			i += 1
			
func hide_equipped_weapons():
	for weapon_icon in equipped_weapons.get_children():
		weapon_icon.queue_free()
