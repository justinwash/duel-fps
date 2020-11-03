extends Control

onready var weapon_buttons = $WeaponButtons.get_children()
onready var equipped_panel = $EquippedPanel
onready var clear_button = $ClearButton

var selected_weapons = []

func _ready():
	for weapon_button in weapon_buttons:
		weapon_button.button.connect("button_up", self, "_select_weapon", [weapon_button])
	
	clear_button.connect("button_up", self, "_clear")
	
func _input(event):
	if event.is_action("ui_cancel"):
		get_node("../../Player").sync_weapon_selection_incoming(selected_weapons)
		
func _physics_process(_delta):
	if !visible:
		return
		
	for button in weapon_buttons:
		var slot = selected_weapons.find(button.WEAPON)
		button.slot_label.text = "" if slot == -1 else ("Q" if slot == 0 else "E")
	
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
		for button in weapon_buttons:
			button.visible = true
	else:
		for button in weapon_buttons:
			button.visible = false
		
		
func _select_weapon(button):
	if !button.selected and len(selected_weapons) < 2:
		button.selected = true
		selected_weapons.append(button.WEAPON.resource_path)
		button.slot_label.text = str(selected_weapons.find(button.WEAPON) + 1)
		equipped_panel.add_equipped_weapon(button)
	else:
		button.selected = false
		selected_weapons.remove(selected_weapons.find(button.WEAPON.resource_path))
		equipped_panel.remove_equipped_weapon(button)

func _clear():
	selected_weapons = []
	get_node("../../Player").sync_weapon_selection_incoming(selected_weapons)
	equipped_panel.remove_all_weapons()
	for button in weapon_buttons:
		button.selected = false
