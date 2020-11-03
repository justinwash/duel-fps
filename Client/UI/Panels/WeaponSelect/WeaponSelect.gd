extends Control

export(NodePath) var CLIENT
onready var client = get_node(CLIENT)

export(NodePath) var NETWORK_HANDLER
onready var network_handler = get_node(NETWORK_HANDLER)

export(NodePath) var DATASTORE
onready var datastore = get_node(DATASTORE)

export var PICK_TIME = 30

onready var weapon_buttons = $WeaponButtons.get_children()
onready var equipped_panel = $EquippedPanel
onready var ready_button = $ReadyButton
onready var cancel_button = $CancelButton
onready var time_remaining = $TimerLabel/Remaining
onready var choices_remaining = $ChooseLabel/Remaining
onready var timer = $PickTimer
onready var load_timer = $LoadTimer
onready var ready_label = $ReadyLabel
onready var panels = get_node("../")

var selected_weapons = []
var ready = false
var time_was
var won_last_round = false
var used_repick = false

signal start_round

func _ready():
	for weapon_button in weapon_buttons:
		weapon_button.button.connect("button_up", self, "_select_weapon", [weapon_button])
	
	ready_button.connect("button_up", self, "_ready_up", [selected_weapons])
	cancel_button.connect("button_up", self, "_repick")

func reset():
	used_repick = false
	ready = false
	sync_ready_state(false)
	timer.disconnect("timeout", self, "_timeout")
	
func start_timer():
	timer.connect("timeout", self, "_timeout", [selected_weapons])
	timer.wait_time = PICK_TIME
	timer.start()
		
func _physics_process(_delta):
	if !visible:
		return
	for button in weapon_buttons:
		var slot = selected_weapons.find(button.WEAPON)
		button.slot_label.text = "" if slot == -1 else ("Q" if slot == 0 else "E")
		
	if len(selected_weapons) == 2:
		ready_button.disabled = false
		choices_remaining.text = '0'
	else:
		if len(selected_weapons) == 1:
			choices_remaining.text = '1'
		else:
			choices_remaining.text = '2'
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
		for button in weapon_buttons:
			button.visible = true
	else:
		for button in weapon_buttons:
			button.visible = false
		
		
func _select_weapon(button):
	if !ready:
		if !button.selected and len(selected_weapons) < 2:
			button.selected = true
			selected_weapons.append(button.WEAPON.resource_path)
			button.slot_label.text = str(selected_weapons.find(button.WEAPON) + 1)
			equipped_panel.add_equipped_weapon(button)
		else:
			if !won_last_round or !used_repick:
				button.selected = false
				selected_weapons.remove(selected_weapons.find(button.WEAPON.resource_path))
				equipped_panel.remove_equipped_weapon(button)
				used_repick = true
		
func _ready_up(weapons):
	print("ready'd up with ", weapons, " selected")
	ready = true
	ready_button.disabled = true
	sync_ready_state(true)
	
func skip_timer():
	timer.start(3)
	cancel_button.disabled = true
	
func sync_ready_state(state):
	var local_player_id = get_tree().get_network_unique_id()
	var game_id = get_tree().get_root().get_node('Main/Client').game_id
	
	var sync_data = {
		'type': 'player_ready_state',
		'game_id': game_id,
		'player_id': local_player_id,
		'ready_state': state
	}
	network_handler.send_data(1, 'client_server_sync', 'client_server_sync', sync_data)
	
func _repick():
	selected_weapons = []
	for button in weapon_buttons:
		button.selected = false
	ready = false
	sync_ready_state(false)
	
func _timeout(weapons):
	timer.disconnect("timeout", self, "_timeout")
	timer.stop()
	while len(selected_weapons) <= 1:
		randomize()
		var rand_weapon_index = randi() % len(weapon_buttons)
		if !selected_weapons.has(weapon_buttons[rand_weapon_index].WEAPON.resource_path):
			selected_weapons.append(weapon_buttons[rand_weapon_index].WEAPON.resource_path)
	ready = true
	emit_signal("start_round", selected_weapons)
	client.switch_panel(null)
