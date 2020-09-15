extends Panel

onready var menu = owner
onready var status = $Status

func _process(_delta):
	if menu.network_handler.connected:
		status.text = 'Ready'
		status.add_color_override("font_color", Color(0,255,0))
	else:
		status.text = 'Unavailable'
		status.add_color_override("font_color", Color(255,0,0))
		
