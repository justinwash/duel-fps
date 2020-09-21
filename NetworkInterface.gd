extends Node

func send_data(target: int, type: String, command: String, data):
	rpc_id(target, 'receive_data', type, command, data)
	
remote func receive_data(type, command, data):
	print('received data: type: ', type, ', command: ', command, ', data: ', data)
	var sender_id = get_tree().get_rpc_sender_id()
	
	var target_node: Node
	match(type):
		# Client -> Server commands
		'player_info':
			target_node = get_node("../Server/PlayerController")
		'client_info':
			target_node = get_node("../Server")
		'matchmaking':
			target_node = get_node("../Server/MatchmakingController")
			
		# Server -> Client commands
		'client_instruction':
			target_node = get_node("../Client")
		_:
			print('no matching type found received data.')
			return
	
	if target_node && target_node.has_method(command):
		target_node.call(command, sender_id, data)
		
	
	
