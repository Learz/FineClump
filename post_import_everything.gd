tool # Needed so it runs in editor
extends EditorScenePostImport

# This sample changes all node names

# Called right after the scene is imported and gets the root node
func post_import(scene):
	# Change all node names to "modified_[oldnodename]"
	if scene != null:
		var mesh = scene.get_child(0) as MeshInstance
#		mesh.scale = Vector3(0.01,0.01,0.01)
		add_collision(mesh)
		mesh.rotation_degrees = Vector3(90,0,0)
	return scene # Remember to return the imported scene

func add_collision(mesh):
	if mesh != null:
		mesh.create_trimesh_collision()
