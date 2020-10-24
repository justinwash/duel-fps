extends Control

export(NodePath) var CLIENT
onready var client = get_node(CLIENT)

onready var result_label = $ResultLabel

func _ready():
	pass
	
func set_text(text):
	result_label.text = text

func _on_Button_button_up():
	for game in client.game_controller.get_children():
		game.queue_free()
	client.change_state('main_menu')
