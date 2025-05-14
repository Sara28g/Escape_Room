extends Node3D

signal sceneover
signal closejoystick
signal openq


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		$"../../Control/qs2".visible=true
		emit_signal("closejoystick")
		print("q2")
