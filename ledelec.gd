extends Node3D

var open = false
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		if open == false:
			$"../../../AnimationPlayer".play("open")
			$"../../../opening".play()
			await get_tree().create_timer(0.5).timeout 
			$"../../../opening".stop()
			open = true
		else:
			$"../../../AnimationPlayer".play("close")
			$"../../../opening".play()
			await get_tree().create_timer(0.5).timeout  
			$"../../../opening".stop()
			open = false
		
