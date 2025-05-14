extends CharacterBody3D
signal rostop2

const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const TOUCH_DRAG_THRESHOLD = 10

@export var touch_sensitivity: float = 0.15
@export var smooth_factor: float = 10.0

@onready var joystick = get_node("../Control/Controller/joystick")
@onready var head = $head
@onready var camera_node = $head/Camera3D

# Using a quaternion for rotation to avoid gimbal lock issues
var target_rotation_y: float = 0.0
var is_rotation_active: bool = false
var camera_dragging = false
var mouse_sensitivity = 0.05
var joystick_input_vector = Vector2.ZERO
var touch_enabled: bool = false
var drag_touch_index: int = -1
var touch_start_position: Vector2 = Vector2.ZERO
var is_touch_drag: bool = false
var last_touch_pos: Vector2 = Vector2.ZERO

func _ready():
	target_rotation_y = rotation.y
	if OS.has_feature("mobile"):
		touch_enabled = true
		print("Mobile device detected, touch controls enabled")

func _unhandled_input(event):
	if touch_enabled:
		_handle_touch_input(event)
	else:
		_handle_mouse_input(event)

func _handle_mouse_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_point_on_joystick(event.position):
			camera_dragging = event.pressed
			# Reset target rotation to current rotation when starting to drag
			if camera_dragging:
				target_rotation_y = rotation.y
				is_rotation_active = true
			else:
				is_rotation_active = false
	
	if event is InputEventMouseMotion and camera_dragging:
		target_rotation_y -= deg_to_rad(event.relative.x * mouse_sensitivity)
		var new_camera_x = camera_node.rotation.x - deg_to_rad(event.relative.y * mouse_sensitivity)
		camera_node.rotation.x = clamp(new_camera_x, deg_to_rad(-80), deg_to_rad(80))

func _handle_touch_input(event):
	if event is InputEventScreenTouch:
		if event.pressed and drag_touch_index == -1 and not is_point_on_joystick(event.position):
			drag_touch_index = event.index
			touch_start_position = event.position
			last_touch_pos = event.position
			is_touch_drag = false
		elif not event.pressed and event.index == drag_touch_index:
			drag_touch_index = -1
			camera_dragging = false
			is_rotation_active = false
	
	elif event is InputEventScreenDrag and event.index == drag_touch_index:
		if not is_touch_drag:
			if touch_start_position.distance_to(event.position) > TOUCH_DRAG_THRESHOLD:
				is_touch_drag = true
				camera_dragging = true
				target_rotation_y = rotation.y
				is_rotation_active = true
		
		if camera_dragging:
			var delta_pos = event.position - last_touch_pos
			last_touch_pos = event.position
			
			# Only update rotation if there's significant movement
			if abs(delta_pos.x) > 0.5 or abs(delta_pos.y) > 0.5:
				target_rotation_y -= deg_to_rad(delta_pos.x * touch_sensitivity)
				var new_camera_x = camera_node.rotation.x - deg_to_rad(delta_pos.y * touch_sensitivity)
				camera_node.rotation.x = clamp(new_camera_x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# Handle rotation completely differently to avoid issues
	if is_rotation_active:
		# Create a new rotation value with only the Y component changing
		var current_rot = Vector3(rotation.x, rotation.y, rotation.z)
		var new_rot = Vector3(current_rot.x, target_rotation_y, current_rot.z)
		
		# Smoothly interpolate only when actively rotating
		if camera_dragging:
			rotation.y = lerp_angle(rotation.y, target_rotation_y, delta * smooth_factor)
		else:
			# Immediately set rotation when not dragging to prevent drift
			rotation.y = target_rotation_y
			is_rotation_active = false
	
	if not is_on_floor():
		velocity.y -= 9.8 * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var key_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir = (joystick_input_vector + key_input).normalized()
	
	var direction = Vector3.ZERO
	var forward = -camera_node.global_transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	
	var right = camera_node.global_transform.basis.x
	right.y = 0
	right = right.normalized()
	
	direction = forward * -input_dir.y + right * input_dir.x
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 10)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 10)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 10)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta * 10)
		
	move_and_slide()

func on_joystick_joystick_input(input_vector: Vector2) -> void:
	joystick_input_vector = input_vector
	
func is_point_on_joystick(point: Vector2) -> bool:
	if not is_instance_valid(joystick):
		return false
		
	var margin = 100
	var joystick_size = joystick.size
	var rect = Rect2(
		joystick.global_position - Vector2(margin, margin),
		joystick_size + Vector2(margin * 2, margin * 2)
	)
	
	return rect.has_point(point)
