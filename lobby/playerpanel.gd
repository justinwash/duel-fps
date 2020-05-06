extends Panel

var t = 0

func _ready():
	var _player_connected = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _player_disconnected = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _player_connected(_id):
	$PlayerLabel2.text = "" + str(_id) if _id != 1 else "Host"
	
func _player_disconnected(_id):
	$PlayerLabel2.text = ""
