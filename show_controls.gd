extends Control



func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("start"):
		if self.visible == true:
			hide()
		elif self.visible != true:
			show()

func _process(delta):
#	if global.katamari_size >= 3:
#		$check1.frame = 1
#	if global.carrot_count >= 1:
#		$check2.frame = 1
#	if global.coal_count >= 2:
#		$check3.frame = 1
#
#	if $check1.frame == 1 && $check2.frame == 1 && $check3.frame == 1:
#		if global.ending_triggered == 0:
#			get_parent().ending()
#			global.ending_triggered = 1
	pass
