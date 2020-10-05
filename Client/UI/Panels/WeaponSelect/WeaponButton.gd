extends Control

export(Resource) var WEAPON

onready var button = $TextureButton
onready var info_panel = get_node('../../InfoPanel')

var selected = false

onready var slot_label = $SlotLabel

func _ready():
	var weapon = WEAPON.instance()
	var _on_button_hover = button.connect("mouse_entered", info_panel, "set_weapon_info", [weapon])
