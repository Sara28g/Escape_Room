extends Node3D

signal sceneover
signal closejoystick

func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick") # Replace with function body.


func _on_close_sceneover() -> void:
	emit_signal("sceneover") # Replace with function body.
