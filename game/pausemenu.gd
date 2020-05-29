extends Control

onready var game = get_node("../../")
onready var panels = get_parent()

func _ready():
	visible = false
	
func _physics_process(_delta):
	if (game.world.players.get_child_count() >= 2 && Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE) or visible:
		
		if Input.is_action_just_pressed('pause'):
			if !visible:
				panels.switch_panel('pause')
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				panels.switch_panel(null)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_LeaveButton_button_up():
	game.cancel_game()
	panels.switch_panel('mainmenu')
