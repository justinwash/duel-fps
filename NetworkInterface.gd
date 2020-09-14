extends Node

func send_data(target, type, data):
	rpc_id(target, 'receive_data', type, data)
	
remote func receive_data(type, data):
	print('received data: type: ', type, ' data: ', data)
	
	match(type):
		'player_info':
			get_node("../Server").register_player(data)
