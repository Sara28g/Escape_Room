extends Control

signal joystick_input(input_vector)

@onready var thumb = $Thumb
@onready var loop = $Loop
@export var deadzone: float = 0.2
@export var max_distance: float = 50.0

var touch_index = -1
var is_pressed = false
var output = Vector2.ZERO
var touch_start_pos = Vector2.ZERO

func _ready():
	thumb.position = loop.position

func _input(event):
	if _is_point_inside_joystick(event.position):
		accept_event()  # 👈 Prevent event from reaching player

	# Mouse support
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and _is_point_inside_joystick(event.position):
				is_pressed = true
				touch_start_pos = event.position
				_update_thumb_position(event.position)
			else:
				is_pressed = false
				_reset_thumb()

	elif event is InputEventMouseMotion and is_pressed:
		_update_thumb_position(event.position)

	# Touch support
	elif event is InputEventScreenTouch:
		if event.pressed and touch_index == -1 and _is_point_inside_joystick(event.position):
			touch_index = event.index
			is_pressed = true
			touch_start_pos = event.position
			_update_thumb_position(event.position)
		elif !event.pressed and event.index == touch_index:
			touch_index = -1
			is_pressed = false
			_reset_thumb()

	elif event is InputEventScreenDrag and event.index == touch_index:
		_update_thumb_position(event.position)

func _reset_thumb():
	thumb.position = loop.position
	output = Vector2.ZERO
	emit_signal("joystick_input", output)

func _update_thumb_position(pos: Vector2):
	var delta_pos = pos - touch_start_pos
	var distance = delta_pos.length()

	if distance > max_distance:
		delta_pos = delta_pos.normalized() * max_distance

	thumb.position = loop.position + delta_pos

	output = delta_pos / max_distance

	if output.length() < deadzone:
		output = Vector2.ZERO
	else:
		output = output.normalized() * ((output.length() - deadzone) / (1 - deadzone))

	emit_signal("joystick_input", output)

func get_output() -> Vector2:
	return output

func _is_point_inside_joystick(point: Vector2) -> bool:
	var center = loop.global_position
	var radius = max_distance * 1.2
	return point.distance_to(center) <= radius

func _on_camera_3d_closejoystick() -> void:
	visible = false
	$Thumb.visible = false
	$Loop.visible = false
	print("joyclose")

func _on_close_sceneover() -> void:
	visible = true
	$Thumb.visible = true
	$Loop.visible = true
