extends Camera3D

signal closebuttons
signal closejoystick
signal nodecall
signal col

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		$".".current=true # Replace with function body.
		$Control.visible=true
		emit_signal("nodecall")
		emit_signal("closejoystick")
		emit_signal("closebuttons")
		
		


func _on_bedding_drawercanopen() -> void:
	$".".current=true # Replace with function body.
	$Control.visible=true
	emit_signal("closejoystick")
	emit_signal("closebuttons")



func _on_table_j_callfunc() -> void:
	emit_signal("playtv")
	$".".current=true # Replace with function body.
	$Control.visible=true
	emit_signal("nodecall")
	emit_signal("closejoystick")
	emit_signal("closebuttons")



		


func _on_train_cam() -> void:
	pass # Replace with function body.


func _on_table_j_gameover() -> void:
	$".".current=true # Replace with function body.
	emit_signal("closejoystick")
	emit_signal("closebuttons")




func _on_closejoystick() -> void:
	pass # Replace with function body.
