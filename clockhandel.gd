extends Sprite2D

@export var step_angle: float = 30.0  # Snap to 5-minute marks (30 degrees per step)
var dragging = false
var target_angle = 0.0

func _ready():
	$".".offset = Vector2(0, -$".".texture.get_height() / 2)  # Set offset at start

func _input(event):
	var mouse_pos = get_global_mouse_position()
	var center_pos = global_position  # Use sprite's actual center

	if event is InputEventMouseButton:
		if event.pressed and get_rect().has_point(to_local(mouse_pos)):  
			dragging = true
		elif not event.pressed:
			dragging = false  

	if dragging and event is InputEventMouseMotion:
		var direction = (mouse_pos - center_pos).normalized()
		var angle = rad_to_deg(atan2(direction.y, direction.x))  # Convert to degrees
		target_angle = round(angle / step_angle) * step_angle  # Snap to closest step

func _process(delta):
	if dragging:
		# Smoothly interpolate towards the target angle
		rotation_degrees = lerp(rotation_degrees, target_angle, delta * 10)
		print($".".rotation)
