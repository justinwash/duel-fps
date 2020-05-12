extends ProgressBar

onready var progress_bar = $ProgressBar
onready var ready_overlay = $ReadyOverlay

func _ready():
	value = 100
	
func _process(_delta):
	progress_bar.value = value
	
	if value >= 100:
		ready_overlay.visible = true
	else:
		ready_overlay.visible = false
