extends MeshInstance3D

signal switch_toggled(node, is_open)
var open = false
var can_touch = true
var cooldown_time = 0.3  # 300ms cooldown between touches
var cooldown_timer = 0.0

func _process(delta):
	# Update cooldown timer
	if not can_touch:
		cooldown_timer += delta
		if cooldown_timer >= cooldown_time:
			can_touch = true
			cooldown_timer = 0.0
			
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and can_touch:
		if open == false:
			$"../../../../AnimationPlayer".play("on5")
			await get_tree().process_frame
			await get_tree().create_timer(0.2).timeout
			$"../../../../AudioStreamPlayer3D".play()
			open = true
			can_touch = false
			cooldown_timer = 0.0
		else:
			$"../../../../AnimationPlayer".play("off5")
			await get_tree().process_frame
			await get_tree().create_timer(0.2).timeout
			$"../../../../AudioStreamPlayer3D".play()
			open = false
			can_touch = false
			cooldown_timer = 0.0
		
		# Emit signal to notify the puzzle controller
		emit_signal("switch_toggled", self, open)
