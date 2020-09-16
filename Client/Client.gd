extends Node

onready var network_handler = $ClientNetworkHandler

onready var panels = {
	'connecting_to_server': $Panels/ConnectingToServer,
	'main_menu': $Panels/MainMenu
}

var current_state
onready var states = {
	"init": $States/Init,
	"idle": $States/Idle,
	"connecting_to_server": $States/ConnectingToServer,
	"main_menu": $States/MainMenu,
	"searching_for_match": $States/SearchingForMatch
}

func _ready():
	current_state = states.init
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
func _process(delta):
	current_state.update(self, delta)
	
func switch_panel(panel_name: String):
	if !panel_name:
		for panel in panels:
			panel.visible = false
	else:
		if panels[panel_name]:
			for panel in panels:
				panels[panel].visible = false
				
			panels[panel_name].visible = true

func change_state(state_name):
	current_state.exit(self)
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	if network_handler.connected:
		network_handler.send_data(1, 'client_info', 'update_client_state', state_name)
