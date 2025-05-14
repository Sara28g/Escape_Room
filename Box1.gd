extends Node3D

var selected_mesh = null
var original_scale = Vector3.ONE
var preview_scale = Vector3(1.5, 1.5, 1.5)
var rotating = false
var rotation_speed = 1.0

func _ready():
	# Set up all meshes with Area3D for click detection
	for child in get_children():
		if child is MeshInstance3D:
			# Check if this mesh already has an Area3D child
			var area = null
			for subchild in child.get_children():
				if subchild is Area3D:
					area = subchild
					break
			
			# If no Area3D exists, create one
			if not area:
				area = Area3D.new()
				child.add_child(area)
				
				# Add collision shape to match the mesh
				var collision_shape = CollisionShape3D.new()
				var shape = BoxShape3D.new()  # Assuming box shape, adjust as needed
				collision_shape.shape = shape
				area.add_child(collision_shape)
			
			# Connect the input event signal
			area.input_event.connect(_on_area_input_event.bind(child))

func _on_area_input_event(_camera, event, _position, _normal, _shape_idx, mesh):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# If clicking on a new mesh
		if selected_mesh != mesh:
			# Reset previous selected mesh if any
			if selected_mesh:
				selected_mesh.scale = original_scale
				
			# Set new selected mesh
			selected_mesh = mesh
			original_scale = mesh.scale
			selected_mesh.scale = preview_scale
			rotating = true

func _process(delta):
	# Rotate the selected mesh if in preview mode
	if selected_mesh and rotating:
		selected_mesh.rotate_y(rotation_speed * delta)
	
	# Check for right click to exit rotation mode or enable manual rotation
	if Input.is_action_just_pressed("ui_cancel") and selected_mesh:
		rotating = !rotating
