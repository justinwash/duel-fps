extends Spatial

onready var player = $Player
onready var dummy = $Dummy
onready var weapon_select = $Overlay/PracticeWeaponSelect

func _ready():
	player.camera.current = true
	player.model.visible = false
	player.offline = true
	
	for hud_element in player.hud.get_children():
			if hud_element.name != 'AnimationPlayer':
				hud_element.visible = true
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		weapon_select.visible = !weapon_select.visible
