extends Control

onready var bg = $Sprite2_bg
onready var bg2 = $Sprite1_bg

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if visible == true:
		bg.rotation_degrees += 1
		bg2.rotation_degrees -= 1
