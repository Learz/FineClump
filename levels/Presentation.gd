extends Control


# Declare member variables here. Examples:
var slide = 1
var transition = false
var t_time = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if transition:
		return
	if event.is_action_pressed("ui_left") and slide > 1:
		get_child(slide).visible = false
		slide -= 1
		get_child(slide).visible = true
	if event.is_action_pressed("click") or event.is_action_pressed("ui_right"):
		if get_child(slide + 1):
			get_child(slide).visible = false
			slide += 1
			get_child(slide).visible = true
		else:
			get_child(slide).visible = false
			var tween = Tween.new()
			add_child(tween)
			tween.interpolate_property(self, "t_time", 1,0,2,Tween.TRANS_QUART,Tween.EASE_IN)
			tween.start()
			transition = true
			yield(tween,"tween_completed")
			queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if transition == true:
		$BG.get_material().set_shader_param("fill", t_time)
	pass
