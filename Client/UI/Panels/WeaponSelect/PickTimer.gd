extends Label

onready var weapon_select = owner
onready var time_remaining_label = $Remaining

func _physics_process(delta):
	time_remaining_label = int(weapon_select.timer.time_left)
