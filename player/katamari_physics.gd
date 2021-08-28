extends RigidBody

#onready var prince = $prince
onready var ball_mesh = $katamari
onready var camera = get_parent().get_node("cam_loc/Camera")
onready var ball_collision = $CollisionShape

onready var left_joy = $Controls/Left_Joystick
onready var right_joy = $Controls/Right_Joystick


var gravity = Vector3(0,-1,0)
var move_speed = 1
var move_vect_3d = Vector3(0,0,0)
var move_vect = Vector2(0,0)

func _input(event):
	if global.presenting:
		return
	if event.is_action_pressed("select"):
		$Controls.visible = !$Controls.visible
	if event.is_action_pressed("ui_right"):
		grow(0.02)
	if event.is_action_pressed("ui_left"):
		grow(0.1)
	if event.is_action_pressed("jump"):
		apply_central_impulse(Vector3.UP*5)


func _ready():
	$Sprite3D.hide()
	global.katamari_size = ball_mesh.get_child(0).get_transformed_aabb().get_area()
	pass


func _physics_process(delta):
	if global.presenting:
		return
	var left_vect = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX),Input.get_joy_axis(0, JOY_ANALOG_LY))
	if left_joy.is_working:
		left_vect = left_joy.output
	var right_vect = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX),Input.get_joy_axis(0, JOY_ANALOG_RY))
	if right_joy.is_working:
		right_vect = right_joy.output
	left_joy.move_joystick(left_vect)
	right_joy.move_joystick(right_vect)
	move_vect = (left_vect + right_vect)/2
	
	if left_vect.y < -.8 && right_vect.y < -.8:
		move_speed = 1.4
	else:
		move_speed = 1
	
	if move_vect.length() < .2:
		move_vect = Vector2(0, 0)
	
	move_vect_3d = Vector3(move_vect.x, 0, move_vect.y)
	var cam_move = Vector3(camera.global_transform.basis.xform(move_vect_3d).x, 0, camera.global_transform.basis.xform(move_vect_3d).z)

	self.apply_impulse(Vector3(0,0,0), cam_move.normalized() * ( $katamari.scale.x * 10 ) * delta)


# Grow the ball
func grow(amount):
	self.mass += amount * .5
	$GUI.update_size_label(ball_mesh.scale.y * 20)
	ball_collision.get_shape().radius += amount
	ball_mesh.scale += Vector3(amount,amount,amount)
	global.katamari_size = ball_mesh.scale

# Play the pick up sound
func pu():
	$pickup_sound.pitch_scale = rand_range(0.5,1.5)
	$pickup_sound.play()

# Get the area of the selected StaticBody
func _get_prop_area(prop):
	return prop.get_child(0).get_aabb().get_area() * prop.scale.x * prop.scale.y * prop.scale.z * prop.get_child(0).scale.x * prop.get_child(0).scale.y * prop.get_child(0).scale.z

#TODO : Rework size comparison, it works but not sure of the ratio
func _on_ScanArea_body_entered(body):
	if body == self:
		return
	body = body as StaticBody
	var prop = body
	if body == null:
		return
	if body.get_parent() != null:
		if body.get_parent().get_parent() != null:
			prop = body.get_parent().get_parent()
		else:
			return
	else:
		return
	var area = _get_prop_area(prop)
	var ball_aabb = ball_mesh.get_child(0).get_aabb() 
#	var ball_comparator = ball_aabb.get_area() * ball_mesh.scale.x * ball_mesh.scale.y * ball_mesh.scale.z
#	$GUI/Katamari_comparator.text = "Katamari : " + str(ball_comparator)
	var prop_aabb = prop.get_child(0).get_aabb() 
	var prop_axis = prop_aabb.get_longest_axis()
#	var prop_comparator = _get_prop_area(prop)
#	var prop_size = prop_aabb.size * prop.scale *  prop.get_child(0).scale
#	if ball_comparator > prop_comparator and ball_aabb.size.x > prop_size.x and ball_aabb.size.y > prop_size.y and ball_aabb.size.z > prop_size.z:
	if ball_aabb.get_longest_axis_size() * ball_mesh.scale.y * 1.0 > prop_aabb.get_longest_axis_size() * (prop.scale * prop_axis).length() * (prop.get_child(0).scale * prop_axis).length():
			body.set_collision_layer_bit(0,0)
			body.set_collision_layer_bit(1,1)
			body.set_collision_mask_bit(0,0)
			body.set_collision_mask_bit(1,1)


func _on_GlomArea_body_entered(body):
	body = body as StaticBody
	var prop = body.get_parent().get_parent()
	if not prop:
		return
	var area = _get_prop_area(prop)
	$GUI/Prop_comparator.text = "Prop : " + str(area)
	body.get_child(0).disabled = true
#	grow(sqrt(sqrt(area))/500)
	grow(sqrt(sqrt(area))/150)
	pu()
	yield(get_tree(), "physics_frame")
	var glo_transform = prop.global_transform
	prop.get_parent().remove_child(prop)
	add_child(prop)
	prop.global_transform = glo_transform


func _on_ClearArea_body_entered(body):
	pass
#	var prop = body.get_parent().get_parent()
#	if prop.get_child(0) is MeshInstance:
#		prop.queue_free()
