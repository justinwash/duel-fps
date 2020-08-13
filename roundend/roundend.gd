extends Control

export var WAIT_TIME = 10

onready var time_remaining = $TimerLabel/Remaining
onready var timer = $PickTimer
onready var load_timer = $LoadTimer
onready var ready_label = $ReadyLabel
onready var player = owner

var selected_weapons = []
var ready = false

signal start_round

func _start_timer():
	timer.connect("timeout", self, "_timeout")
	timer.wait_time = WAIT_TIME
	timer.start()
		
func _physics_process(_delta):
	time_remaining.text = str(int(timer.time_left))
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 

func _timeout():
	if owner.is_master_or_player(1):
		owner.set_ready(false)
		owner.rpc("set_ready", false)
	else:
		owner.set_ready(false)
	
	for weapon in owner.weapons:
		weapon.queue_free()
	owner.change_state("picking")
