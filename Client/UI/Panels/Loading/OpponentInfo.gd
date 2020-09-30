extends Panel

onready var opponent_data = $OpponentData
onready var player_data = $PlayerData

onready var datastore = owner.datastore

func _process(_delta):
	if !datastore:
		datastore = owner.datastore
		
	if visible == true && datastore:
		if datastore.db.has('player_info'):
			player_data.text = datastore.db['player_info'].name
			player_data.add_color_override("font_color", datastore.db['player_info'].color)
			
		if datastore.db.has('opponent_info'):
			opponent_data.text = datastore.db['opponent_info'].client_info.player.name
			opponent_data.add_color_override("font_color", datastore.db['opponent_info'].client_info.player.color)
