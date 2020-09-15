extends Panel

onready var player_name = $PlayerName

export(NodePath) var DATASTORE
onready var datastore = get_node(DATASTORE)

var initialized = false

func _physics_process(_delta):
	if owner.datastore && !initialized && 'player_info' in datastore.db:
		player_name.text = datastore.db['player_info'].name
		player_name.add_color_override("font_color", datastore.db['player_info'].color)
		initialized = true
