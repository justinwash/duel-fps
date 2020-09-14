extends Node

onready var network_handler = $ClientNetworkHandler

onready var panels = {
	'connection_status': $Panels/ConnectionStatus
}

func _ready():
	pass
	
func switch_panel(panel_name: String):
	if !panel_name:
		for panel in panels:
			panel.visible = false
	else:
		if panels[panel_name]:
			for panel in panels:
				panel.visible = false
				
			panels[panel_name].visible = true
