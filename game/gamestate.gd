extends Node
onready var game = get_parent()

var current_state
onready var states = {
	"menu": $Menu,
	"roundstart": $RoundStart
}

func _ready():
	current_state = states.menu
	if current_state.has_method("ready"):
		current_state.ready(game)
	current_state.enter(game)

func is_master_or_player(id):
	if (get_tree().has_network_peer() and is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() == id):
		return true
	else:
		return false
		
func change_state(state_name):
	current_state.exit(game)
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(game)
	current_state.enter(game)
	
