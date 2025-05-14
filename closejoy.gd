extends Control


func _on_closejoystick() -> void:
	$".".visible=false # Replace with function body.
	$joystick.visible=false


func _on_frame_sceneover() -> void:
	$joystick.visible=true
	$".".visible=true # Replace with function body.
