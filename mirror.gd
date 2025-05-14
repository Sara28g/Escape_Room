extends Node3D

signal sceneover
signal closejoystick
signal closecam
signal close
func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick") # Replace with function body.


func _on_close_sceneover() -> void:
	emit_signal("sceneover") # Replace with function body.


func _on_camera_3d_closebuttons() -> void:
	emit_signal("close") # Replace with function body.


func _on_table_closecams() -> void:
	emit_signal("closecam") # Replace with function body.
