extends Node

var mode

func _process(_delta):
	if mode:
		mode.process()
		
