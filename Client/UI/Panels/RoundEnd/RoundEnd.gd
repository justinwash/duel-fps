extends Control

onready var result_label = $ResultLabel
onready var animation_player = $AnimationPlayer

func _ready():
	pass
	
func play_anim():
	animation_player.play("text_enter")
	
func set_text(text):
	result_label.text = text
