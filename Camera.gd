extends KinematicBody

onready var katamari = get_parent().get_node("katamari_physics")
onready var cam = $Camera
onready var spatial = $Spatial
onready var prince = $prince

onready var camera_dist = 0

var prince_pushing = false

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_up"):
		camera_dist -= 0.2
	if event.is_action_pressed("ui_down"):
		camera_dist += 0.2
	if event is InputEventMouseButton and event.is_pressed():
		var from = $Camera.project_ray_origin(event.position)
		var to = from + $Camera.project_local_ray_normal(event.position) * 2000
		$Camera/RayCast.global_transform.origin = from
		$Camera/RayCast.cast_to = to
		var clicked_obj = $Camera/RayCast.get_collider()
		if clicked_obj:
			if clicked_obj.get_parent() != null:
				if clicked_obj.get_parent().get_parent() != null:
					var prop = clicked_obj.get_parent().get_parent()
					katamari.get_node("GUI/Prop_comparator").text = str(prop.name)
				else:
					return
			else:
				return
	if event.is_action_pressed("quick_turn"):
#		print("quick_turn")
		var current_rot = self.rotation_degrees
		$Tween.interpolate_property(self, "rotation_degrees", current_rot, current_rot + Vector3(0,180,0), .25, Tween.TRANS_QUINT, Tween.EASE_OUT, 0)
		$Tween.start()

func _process(delta):
	pass

func _physics_process(delta):
	var left_vect = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX),Input.get_joy_axis(0, JOY_ANALOG_LY))
	if katamari.left_joy.is_working:
		left_vect = katamari.left_joy.output
	var right_vect = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX),Input.get_joy_axis(0, JOY_ANALOG_RY))
	if katamari.right_joy.is_working:
		right_vect = katamari.right_joy.output
	
	if left_vect.length() + right_vect.length() > 0.2:
		self.rotation.y += (left_vect.y- right_vect.y)/50
	
	if katamari.move_vect.length() > 0.2:
		prince_pushing = true
	else:
		prince_pushing = false
	
#	if prince_pushing == true:
#		if !$prince/AnimationPlayer.is_playing():
#			$prince/AnimationPlayer.play("default")
#	else:
#		$prince/AnimationPlayer.stop()
	
	$prince/AnimationPlayer.play("default")
	$prince/AnimationPlayer.playback_speed = katamari.linear_velocity.length() / 2
	
	move_and_slide((katamari.global_transform.origin - self.global_transform.origin) * 5000 * delta)
	
	var radius = katamari.ball_collision.get_shape().radius
	prince.translation = Vector3(0, -radius / 4 , radius + 0.5)
	
	cam.translation = Vector3(0, (radius + camera_dist) * 1.8  , (radius + camera_dist) * 2)
	cam.look_at(katamari.global_transform.origin + Vector3(0,radius*0.75,0), Vector3.UP)
