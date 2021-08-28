extends Spatial

onready var katamari = $katamari_physics

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("mute"):
		$bg_music.stream_paused = !$bg_music.stream_paused
	if event.is_action_pressed("reset"):
		$katamari_physics.translation = Vector3(-15,8,16.5)
	if event.is_action_pressed("start"):
		get_tree().change_scene("res://levels/Android_level.tscn")

func process():
	pass
		
func ending():
	katamari.mode = 3
	$AnimationPlayer.play("ending")

func _on_Presentation_tree_exited():
	$bg_music.play()
#	$bg_noise.play()
	global.presenting = false
