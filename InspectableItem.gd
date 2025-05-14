extends Node3D

@export var preview_distance: float = 2.0  # Distance from camera when previewing
@export var preview_scale: Vector3 = Vector3(2, 2, 2)  # Scale when previewing
@export var rotation_speed: float = 0.01  # Rotation speed

var is_previewing = false
var is_rotating = false
var original_transform
var camera: Camera3D

func _ready():
	original_transform = global_transform
	find_camera()  # Automatically search for Camera3D

func find_camera():
	# Try to get the active camera in the scene
	camera = get_viewport().get_camera_3d()
	
	if camera:
		print("Camera found:", camera)
	else:
		print("ERROR: No Camera3D found in the scene!")

func _on_area_3d_input_event(_camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not is_previewing:
				preview_item()
			else:
				is_rotating = true
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			close_preview()
	elif event is InputEventMouseMotion and is_rotating:
		rotate_y(-event.relative.x * rotation_speed)
		rotate_x(-event.relative.y * rotation_speed)
	elif event is InputEventMouseButton and not event.pressed:
		is_rotating = false

func preview_item():
	if not camera:
		find_camera()
		if not camera:
			print("Still no Camera found!")
			return

	is_previewing = true
	enable_blur(true)

	var target_position = camera.global_transform.origin + (camera.global_transform.basis.z * -preview_distance)
	target_position.y = global_transform.origin.y  # Keep Y position unchanged

	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_transform:origin", target_position, 0.5)
	tween.tween_property(self, "scale", preview_scale, 0.5)

func close_preview():
	if is_previewing:
		is_previewing = false
		enable_blur(false)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_transform", original_transform, 0.5)

# Enable or disable blur effect
func enable_blur(enable: bool):
	var world_env = get_viewport().find_child("WorldEnvironment", true, false)
	if world_env:
		world_env.environment.glow_enabled = enable
