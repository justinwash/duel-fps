extends Node

func send_data(target, type, data):
	rpc_id(target, 'receive_data', type, data)
	
remote func receive_data(type, data):
	print('received data: type: ', type, ' data: ', data)
	var sender_id = get_tree().get_rpc_sender_id()
	
	match(type):
		'player_info':
			get_node("../Server").register_player(sender_id, data)
		'client_state':
			get_node("../Server").update_client_state(sender_id, data)
