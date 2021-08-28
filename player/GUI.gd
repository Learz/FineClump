extends Control


# Declare member variables here. Examples:
onready var katamari = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BG_meter1.rect_rotation += 10 * delta
	$BG_meter2.rect_rotation += 15 * delta
	pass
	
func update_size_label(size):
	if size < 100:
		$Size_Label.text = str(size).pad_decimals(0) + "cm" + str(size*100).pad_decimals(0).right(2) + "mm"
	else:
		$Size_Label.text = str(size/100).pad_decimals(0) + "m" + str(size).pad_decimals(0).right(1) + "cm"
	$Size_Label_Outline.text = $Size_Label.text
