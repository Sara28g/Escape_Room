extends CSGPolygon3D


# Called when the node enters the scene tree for the first time.
signal j1_t

var j1_taken = false

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		
		j1_taken = true
		emit_signal("j1_t")
		$".".visible=false
