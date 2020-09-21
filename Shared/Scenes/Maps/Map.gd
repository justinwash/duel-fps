extends Node

export var map_name = 'testmap'

onready var spawns = $Spawns

func _ready():
	print('map ' + map_name + ' loaded successfully')
