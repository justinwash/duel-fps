extends Node

var current_state
onready var states = {
	"menu": $Menu,
	"roundstart": $RoundStart
}

func _ready():
	current_state = states.menu
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)

func is_master_or_player(id):
	if (get_tree().has_network_peer() and is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() == id):
		return true
	else:
		return false
		
func change_state(state_name):
	current_state.exit(self)
	current_state = states[state_name]
	if current_state.has_method("ready"):
		current_state.ready(self)
	current_state.enter(self)
	
