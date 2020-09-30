extends Node

export(String, 'SERVER', 'CLIENT') var MODE = 'CLIENT'

onready var network_interface = $NetworkInterface

var arguments = {}

func _ready():
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
			
	if 'mode' in arguments:
		if ['SERVER', 'CLIENT'].has(arguments.mode):
			MODE = arguments.mode
		else:
			OS.alert('Invalid mode specified. Expected SERVER or CLIENT.')
			get_tree().quit()
	
	if MODE == 'SERVER':
		var server_scene = preload("res://Server/Server.tscn").instance()
		add_child(server_scene)
	elif MODE == 'CLIENT':
		var client_scene = preload("res://Client/Client.tscn").instance()
		add_child(client_scene)
	else:
		OS.alert('Invalid mode specified. Expected SERVER or CLIENT.')
		get_tree().quit()
		
	print('Running in mode: ', MODE)
