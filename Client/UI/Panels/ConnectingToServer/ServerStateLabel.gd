extends Label

func _process(_delta):
	if owner.network_handler && owner.network_handler.connected:
		text = 'Connected'
	elif !owner.network_handler || owner.network_handler.connected == null:
		text = 'Attempting to connect to server...'
	else:
		text = 'Disconnected'
