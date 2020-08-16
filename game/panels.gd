extends Node

onready var game = get_parent()

onready var panels = {
	"main": $Main,
	"lobby": $Lobby,
	"pause": $Pause,
	"roundstart": $RoundStart,
	"roundend": $RoundEnd
}

func _ready():
	var _start_practice = panels.main.connect("start_practice", game, "_start_practice")
	switch_panel("main")
	
func switch_panel(panel_name):
	if !panel_name:
		for panel in panels:
			panels[panel].visible = false
	else:
		for panel in panels:
			if panel == panel_name:
				panels[panel].visible = true
			else:
				panels[panel].visible = false
