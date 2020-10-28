extends Spatial

onready var player = $Player

func _ready():
	player.camera.current = true
	player.model.visible = false
	player.offline = true
