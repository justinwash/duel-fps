extends Control

export(NodePath) var CLIENT
onready var client = get_node(CLIENT)

export(NodePath) var NETWORK_HANDLER
onready var network_handler = get_node(NETWORK_HANDLER)

export(NodePath) var DATASTORE
onready var datastore = get_node(DATASTORE)


func _on_OfflineButton_button_up():
	client.change_state('practice')
