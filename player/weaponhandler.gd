extends Spatial

var current_weapon
onready var hud = get_node("../../HUD")
onready var camera = get_node("../Camera")

onready var primary_slot = $Primary
onready var secondary_slot = $Secondary

onready var weapons = {
	"primary": null,
	"secondary": null
}

func weapons_selected():
	return weapons.primary and weapons.secondary

func on_ready():
	for weapon in weapons:
		weapons[weapon].global_transform = camera.global_transform
	current_weapon = weapons.primary
	
	if current_weapon.has_method("ready"):
		current_weapon.ready(self)
	current_weapon.enter(self)

func _process(delta):
	if is_master_or_player(1) and weapons_selected():
		current_weapon.update(self, delta)
		
func _physics_process(delta):
	if is_master_or_player(1) and weapons_selected():
		current_weapon.physics_update(self, delta)

func _input(event):
	if is_master_or_player(1):
		if event is InputEventMouseButton and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			current_weapon.on_input(self, event)
	
func is_master_or_player(id):
	if (get_tree().has_network_peer() and is_network_master()) \
	or (!get_tree().has_network_peer() and get_network_master() == id):
		return true
	else:
		return false
		
func toggle_weapon():
	current_weapon.exit(self)
	
	if current_weapon == weapons.primary:
		current_weapon = weapons.secondary
	else:
		current_weapon = weapons.primary
		
	if current_weapon.has_method("ready"):
		current_weapon.ready(self)
	current_weapon.enter(self)
	
func select_weapon(primary_or_secondary):
	current_weapon.exit(self)
	
	if current_weapon != weapons[primary_or_secondary]:
		current_weapon = weapons[primary_or_secondary]
		
		if current_weapon.has_method("ready"):
			current_weapon.ready(self)
		current_weapon.enter(self)
	
