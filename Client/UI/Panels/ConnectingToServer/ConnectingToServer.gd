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

onready var viewport = $Viewport
onready var model = $Viewport/spaceboi
onready var viewport_sprite = $ViewportSprite

func _ready():
	var _play_button_pressed = play_button.connect('button_up', self, '_play_button_pressed')
	play_button.disabled = true
	
	render_model_preview()
	
func _process(_delta):
	if len(name_box.text) >= 3 && network_handler.connected:
		play_button.disabled = false
	else:
		play_button.disabled = true
		
	viewport_sprite.texture = viewport.get_texture()
		
func _play_button_pressed():
	if network_handler.connected:
		var player_info = {
			'name': name_box.text,
			'color': color_picker.color
		}
	
		datastore.add_entry('player_info', player_info)
		network_handler.send_data(1, 'player_info', 'register_player', player_info)
		client.change_state('main_menu')
		
func render_model_preview():
	# We want Godot to load everything but be hidden for a bit.
	viewport_sprite.modulate = Color(1, 1, 1, 0.01)
	#warning-ignore:return_value_discarded
	get_viewport().connect("size_changed", self, "_root_viewport_size_changed")

	# Assign the sprite's texture to the viewport texture.
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	# Let two frames pass to make sure the screen was captured.
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	viewport_sprite.texture = viewport.get_texture()
	# Hide a little bit longer just in case.
	for _unused in range(50):
		yield(get_tree(), "idle_frame")
	viewport_sprite.modulate = Color.white # Default modulate color.


func _on_ColorPicker_color_changed(color):
	var raw_model = model.get_child(0).get_child(0)
	for mesh in raw_model.get_children():
		if mesh.name != 'Head':
			mesh.get_surface_material(0).albedo_color = color
