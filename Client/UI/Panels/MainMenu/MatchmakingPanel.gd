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
		
func _on_FindMatchButton_button_up():
	menu.network_handler.send_data(1, 'matchmaking', 'add_to_queue', null)
	menu.network_handler.send_data(1, 'client_info', 'update_client_state', 'in_matchmaking_queue')
