extends Camera3D
@export var zoom_speed: float = 2.0
@export var rotate_speed: float = 0.01
@export var min_zoom: float = 2.0
@export var max_zoom: float = 10.0
var dragstop = false
var zoom_level: float = 5.0
var is_rotating: bool = false
var rotation_input: Vector2 = Vector2.ZERO

func _ready():
	# Initialize position - if you want the camera to be offset from the head
	# Otherwise, this isn't needed as the camera is already positioned properly in the scene
	pass

func _input(event):
	# Don't process camera input if drag is stopped
	if dragstop:
		return
		
	# Zoom handling
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_level = max(min_zoom, zoom_level - zoom_speed)
			# Adjust for first-person camera if needed
			# position = position.normalized() * zoom_level
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_level = min(max_zoom, zoom_level + zoom_speed)
			# Adjust for first-person camera if needed
			# position = position.normalized() * zoom_level
		
		# Rotation toggle
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_rotating = event.pressed
			rotation_input = Vector2.ZERO
			
	# Only rotate when right mouse button is held
	if event is InputEventMouseMotion and is_rotating:
		rotation_input = event.relative

func _process(delta):
	# Apply rotation only when right mouse button is held
	if is_rotating and rotation_input != Vector2.ZERO and not dragstop:
		rotation.y -= rotation_input.x * rotate_speed
		rotation.x -= rotation_input.y * rotate_speed
		
		# Clamp vertical rotation to prevent camera flipping
		rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
		# Reset rotation input after processing
		rotation_input = Vector2.ZERO

func on_player_rostop_2() -> void:
	dragstop = true
	print("drag stop")
