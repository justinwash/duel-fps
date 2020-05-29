extends Control

onready var panels = get_parent()

signal start_practice

func _on_PracticeButton_button_up():
	emit_signal("start_practice")
	panels.switch_panel(null)

func _on_MultiplayerButton_button_up():
	panels.switch_panel('lobby')

func _on_QuitButton_button_up():
	get_tree().quit()
