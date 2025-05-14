extends Button

signal sceneover


func _on_pressed() -> void:
	$"../..".current=false
	emit_signal("sceneover")
	$"..".visible=false


func _on_c_3_closecam() -> void:
	$"../..".current=false
	emit_signal("sceneover")
	$"..".visible=false


func _on_camera_3d_closebuttons() -> void:
	$"../..".current=false
	$"..".visible=false
