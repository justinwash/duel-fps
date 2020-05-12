extends Node

var current_weapon
onready var hud = get_node("../HUD")

onready var weapons = {
	"primary": $Primary.get_child(0),
	"secondary": $Secondary.get_child(0)
}

func _ready():	
	current_weapon = weapons.primary
	if current_weapon.has_method("ready"):
		current_weapon.ready(self)
	current_weapon.enter(self)

func _process(delta):
	if is_master_or_player(1):
		current_weapon.update(self, delta)
		
func _physics_process(delta):
	if is_master_or_player(1):
		current_weapon.physics_update(self, delta)
		
		if get_tree().has_network_peer():
		#	rpc_unreliable("set_pos", global_transform)
			pass

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
	current_weapon.exit()
	
	if current_weapon == weapons.primary:
		current_weapon = weapons.secondary
	else:
		current_weapon = weapons.primary
		
	if current_weapon.has_method("ready"):
		current_weapon.ready(self)
	current_weapon.enter(self)
	
func select_weapon(primary_or_secondary):
	current_weapon.exit()
	
	current_weapon = weapons[primary_or_secondary]
		
	if current_weapon.has_method("ready"):
		current_weapon.ready(self)
	current_weapon.enter(self)
	
