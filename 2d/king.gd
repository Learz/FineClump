extends Control

onready var bg = $Sprite2_bg
onready var bg2 = $Sprite1_bg

onready var the_game = preload("res://levels/Class_level.tscn")

onready var text = get_parent().get_node("king_text")
onready var anim = get_parent().get_node("AnimationPlayer")

var count = -1

var script_1 = [
	"It's a lovely snowy day outside and I've decided to build a snowman",
	"However I've been overcome with a sudden bout of laziness",
	"could you perhaps, finish it for me?  This SNOWMAN needs a HEAD...",
	"Roll up a ball of snow and whatever else, say at least 30cm?",
	"Don't forget to roll up a CARROT for a nose",
	"and some COALS for the eyes!",
	"press START at any time to see the CONTROLS and OBJECTIVES",
	"Good luck sweet prince!"
]

func _input(event):
	if visible == true:
		if event.is_action_pressed("ui_accept") && !anim.is_playing():
			anim.play("text_fade")


func _ready():
	anim.play("intro")
	pass

func _process(delta):
	if visible == true:
		bg.rotation_degrees += 1
		bg2.rotation_degrees -= 1

func next_text():
	
	count += 1
	if count < 8:
		text.set_text(script_1[count])
	if count >= 8:
		get_parent().get_parent().add_child(the_game.instance())
		get_parent().queue_free()
