extends Node

onready var network_handler = $ClientNetworkHandler
onready var game_controller = $GameController

onready var panels = {
	'connecting_to_server': $Panels/ConnectingToServer,
	'main_menu': $Panels/MainMenu,
	'weapon_select': $Panels/WeaponSelect,
	'loading': $Panels/Loading
}

var current_state
onready var states = {
	"init": $States/Init,
	"idle": $States/Idle,
	"connecting_to_server": $States/ConnectingToServer,
	"main_menu": $States/MainMenu,
	"searching_for_match": $States/SearchingForMatch,
	"loading": $States/Loading,
	"weapon_select": $States/WeaponSelect,
	"start_game": $States/StartGame,
	"in_game": $States/InGame
}

func _ready():
	current_state = states.init
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
func _process(delta):
	current_state.update(self, delta)
	
func switch_panel(panel_name):
	if !panel_name:
		for panel in panels:
			panels[panel].visible = false
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
		
func start_game(_remote_id, opponent_info):
	change_state('start_game')
	game_controller.start_game(opponent_info)
	
func end_game(_remote_id, _data):
	game_controller.end_game()
