extends Panel

onready var menu = owner
onready var status = $Status
onready var find_match_button = $FindMatchButton
onready var cancel_button = $CancelButton

var searching = false

func _process(_delta):
	if menu.network_handler.connected:
		status.text = 'Ready'
		status.add_color_override("font_color", Color(0,255,0))
		
		if searching:
			status.text = 'Searching...'
			find_match_button.disabled = true
			cancel_button.disabled = false
		else:
			find_match_button.disabled = false
			cancel_button.disabled = true
	else:
		status.text = 'Unavailable'
		find_match_button.disabled = true
		cancel_button.disabled = true
		searching = false
		status.add_color_override("font_color", Color(255,0,0))
		
func _on_FindMatchButton_button_up():
	if !searching:
		searching = true
		
	menu.network_handler.send_data(1, 'matchmaking', 'add_to_queue', null)
	menu.network_handler.send_data(1, 'client_info', 'update_client_state', 'in_matchmaking_queue')
	
func _on_CancelButton_button_up():
	if searching:
		searching = false
	menu.network_handler.send_data(1, 'matchmaking', 'remove_from_queue', null)
	menu.network_handler.send_data(1, 'client_info', 'update_client_state', 'main_menu')
