extends Node3D

var is_focused = false
var original_position = Vector3.ZERO
var original_rotation = Vector3.ZERO
var focus_distance = 2.0  # Adjustable distance for focused view

@onready var camera = get_viewport().get_camera_3d()

func _ready():
	# Store original transform
	original_position = global_position
	original_rotation = rotation
	
	# Connect input event
	$Area3D.input_event.connect(_on_area_3d_input_event)

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or \
	   (event is InputEventScreenTouch and event.pressed):
		toggle_focus()
		get_viewport().set_input_as_handled()

func toggle_focus():
	is_focused = !is_focused
	
	# Tell the camera about focus change
	camera.set_object_focus(is_focused, self if is_focused else null)
	
	if is_focused:
		# Instead of moving the object, move and rotate the camera to look at it
		var tween = create_tween()
		
		# Calculate camera position
		var direction_to_camera = (camera.global_position - global_position).normalized()
		var target_camera_position = global_position + direction_to_camera * focus_distance
		
		# Store original camera values
		var original_camera_pos = camera.global_position
		var original_camera_rot = camera.global_rotation
		
		# Set these as metadata on camera for when we unfocus
		camera.set_meta("original_position", original_camera_pos)
		camera.set_meta("original_rotation", original_camera_rot)
		
		# Move camera to look at object
		tween.tween_property(camera, "global_position", target_camera_position, 0.5)
		
		# Make camera look at object
		var look_at_tween = func(weight: float):
			var target_transform = camera.global_transform.looking_at(global_position)
			camera.global_transform = camera.global_transform.interpolate_with(target_transform, weight)
			
		tween.tween_method(look_at_tween, 0.0, 1.0, 0.5)
	else:
		# Restore camera to original position
		if camera.has_meta("original_position") and camera.has_meta("original_rotation"):
			var tween = create_tween()
			tween.tween_property(camera, "global_position", camera.get_meta("original_position"), 0.5)
			tween.tween_property(camera, "global_rotation", camera.get_meta("original_rotation"), 0.5)

func _unhandled_input(event):
	if !is_focused:
		return
		
	# Desktop object rotation controls
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		rotate_y(-event.relative.x * 0.01)
		rotate_x(-event.relative.y * 0.01)
		get_viewport().set_input_as_handled()
	
	# Mobile object rotation controls
	if event is InputEventScreenDrag:
		rotate_y(-event.relative.x * 0.005)
		rotate_x(-event.relative.y * 0.005)
		get_viewport().set_input_as_handled()
