extends StaticBody

onready var katamari = null

export var threshold = 1.9
export var contribution = .01

var check_size = true
var picked = false

func _ready():
	$pickup_area/CollisionShape.disabled = true
	pass

func _physics_process(delta):
	if check_size == true:
		if global.katamari_size > get_child(0).get_aabb().get_area():
			$phys_collide.disabled = true
			$pickup_area/CollisionShape.disabled = false
			check_size = false
	pass

func glom():
	$pickup_area/CollisionShape.disabled = true
	var glo_transform = self.global_transform
	get_parent().remove_child(self)
	katamari.add_child(self)
	self.global_transform = glo_transform

		
func _on_pickup_area_body_entered(body):
	if body.get_name() == "katamari_physics":
		katamari = body
		body.grow(contribution)
		body.pu()
		if self.is_in_group("coal"):
			global.coal_count += 1
		if self.is_in_group("carrot"):
			global.carrot_count += 1
		yield(get_tree(), "physics_frame")
		glom()
	pass
