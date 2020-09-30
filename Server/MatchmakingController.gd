extends Node

onready var server = owner
onready var clients = owner.clients
onready var game_controller = get_node("../GameController")

var queue = []

func add_to_queue(client_id, _gametype_or_something):
	if clients[client_id] && !queue.has(client_id):
		queue.append(client_id)

func _on_Timer_timeout():
	if len(queue) >= 2:
		while len(queue) >= 2:
			server.update_client_state(queue[0], 'match_found')
			server.update_client_state(queue[1], 'match_found')
			game_controller.create_game(queue[0], queue[1])
			queue.pop_front()
			queue.pop_front()
		
