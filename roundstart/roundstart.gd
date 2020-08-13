extends Control

export var PICK_TIME = 10

onready var weapon_buttons = $WeaponButtons.get_children()
onready var ready_button = $ReadyButton
onready var cancel_button = $CancelButton
onready var time_remaining = $TimerLabel/Remaining
onready var timer = $PickTimer
onready var load_timer = $LoadTimer
onready var ready_label = $ReadyLabel

var selected_weapons = []
var ready = false

signal start_round

func _ready():
	for button in weapon_buttons:
		button.connect("button_up", self, "_select_weapon", [button])
	
	ready_button.connect("button_up", self, "_ready_up", [selected_weapons])
	cancel_button.connect("button_up", self, "_repick")

func reset():
	selected_weapons = []
	ready = false
	timer.disconnect("timeout", self, "_timeout")
	
func _start_timer():
	timer.connect("timeout", self, "_timeout", [selected_weapons])
	timer.wait_time = PICK_TIME
	timer.start()
		
func _physics_process(_delta):
	for button in weapon_buttons:
		var slot = selected_weapons.find(button.WEAPON)
		button.slot_label.text = "" if slot == -1 else ("Q" if slot == 0 else "E")
		
	if len(selected_weapons) == 2:
		ready_button.disabled = false
	else:
		ready_button.disabled = true
	
	if !ready:
		ready_label.text = ""
		cancel_button.disabled = true
	else:
		ready_label.text = "Ready"
		ready_button.disabled = true
		cancel_button.disabled = false
		
	time_remaining.text = str(int(timer.time_left))
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
		
func _select_weapon(button):
	if !ready:
		if !button.selected and len(selected_weapons) < 2:
			button.selected = true
			selected_weapons.append(button.WEAPON)
			button.slot_label.text = str(selected_weapons.find(button.WEAPON) + 1)
			print("added ", button.WEAPON.instance().name, " to selection")
		else:
			button.selected = false
			selected_weapons.remove(selected_weapons.find(button.WEAPON))
			print("removed ", button.WEAPON.instance().name, " from selection")
		
func _ready_up(weapons):
	print("ready'd up with ", weapons, " selected")
	ready = true
	ready_button.disabled = true
	
func _repick():
	print("repick clicked")
	selected_weapons = []
	for button in weapon_buttons:
		button.selected = false
	ready = false
	
	
func _timeout(weapons):
	print("timed out with ", weapons, " selected")
	timer.disconnect("timeout", self, "_timeout")
	timer.stop()
	while len(selected_weapons) != 2:
		randomize()
		var rand_weapon_index = randi() % len(weapon_buttons)
		if !selected_weapons.has(weapon_buttons[rand_weapon_index].WEAPON):
			selected_weapons.append(weapon_buttons[rand_weapon_index].WEAPON)
			
	print("forced ready with ", selected_weapons)
	ready = true
	for button in weapon_buttons:
		button.visible = false
	emit_signal("start_round", selected_weapons)
