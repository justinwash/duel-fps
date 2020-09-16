extends Control

export(NodePath) var CLIENT
onready var client = get_node(CLIENT)

export(NodePath) var NETWORK_HANDLER
onready var network_handler = get_node(NETWORK_HANDLER)

export(NodePath) var DATASTORE
onready var datastore = get_node(DATASTORE)

onready var name_box = $NameBox
onready var color_picker = $ColorPicker
onready var play_button = $PlayButton

func _ready():
	var _play_button_pressed = play_button.connect('button_up', self, '_play_button_pressed')
	play_button.disabled = true
	
func _process(_delta):
	if len(name_box.text) >= 3 && network_handler.connected:
		play_button.disabled = false
	else:
		play_button.disabled = true
		
func _play_button_pressed():
	if network_handler.connected:
		var player_info = {
			'name': name_box.text,
			'color': color_picker.color
		}
	
		datastore.add_entry('player_info', player_info)
		network_handler.send_data(1, 'player_info', 'register_player', player_info)
		client.change_state('main_menu')
