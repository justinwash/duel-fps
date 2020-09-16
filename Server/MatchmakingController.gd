extends Node

onready var clients = owner.clients
onready var game_controller = get_node("../GameController")

var queue = []

func add_to_queue(client_id, _gametype_or_something):
	if clients[client_id] && !queue.has(client_id):
		queue.append(client_id)

func _on_Timer_timeout():
	if len(queue) >= 2:
		for i in range(0, len(queue)):
			if queue[i] && i + 1 < len(queue):
				game_controller.create_game(queue[i], queue[i+1])
				i = i + 2
		
