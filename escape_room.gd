extends Node3D  # Base class for 3D scenes in Godot 4

func _ready():
	# Create walls using MeshInstance3D
	create_wall("Back", Vector3(0, 2, -5), Vector3(10, 4, 0.2))
	create_wall("Front", Vector3(0, 2, 5), Vector3(10, 4, 0.2))
	create_wall("Left", Vector3(-5, 2, 0), Vector3(0.2, 4, 10))
	create_wall("Right", Vector3(5, 2, 0), Vector3(0.2, 4, 10))
	
	# Create floor
	create_floor()

func create_wall(name: String, position: Vector3, size: Vector3):
	# Create a wall mesh
	var wall = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	
	# Set mesh dimensions
	box_mesh.size = size
	wall.mesh = box_mesh
	
	# Position the wall
	wall.position = position
	wall.name = name + "Wall"
	
	# Add material for texture
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.7, 0.7, 0.7)  # Gray wall color
	wall.material_override = material
	
	# Add collision
	var static_body = StaticBody3D.new()
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = BoxShape3D.new()
	collision_shape.shape.size = size
	
	static_body.add_child(collision_shape)
	wall.add_child(static_body)
	
	# Add to scene
	add_child(wall)

func create_floor():
	var floor_mesh = MeshInstance3D.new()
	var plane_mesh = PlaneMesh.new()
	
	# Set floor size
	plane_mesh.size = Vector2(10, 10)
	floor_mesh.mesh = plane_mesh
	
	# Position floor
	floor_mesh.position = Vector3(0, 0, 0)
	floor_mesh.rotation_degrees.x = 0
	
	# Add material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.5, 0.5, 0.5)  # Gray floor
	floor_mesh.material_override = material
	
	# Add collision
	var static_body = StaticBody3D.new()
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(10, 0.2, 10)
	
	collision_shape.shape = box_shape
	static_body.add_child(collision_shape)
	floor_mesh.add_child(static_body)
	
	add_child(floor_mesh)
