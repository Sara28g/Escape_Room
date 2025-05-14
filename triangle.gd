extends Node3D
signal closejoystick
var lighton=true
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
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed :
		emit_signal("closejoystick")
		$"../../Control/qs5".visible=true

func _on_qs_5_correct_5() -> void:
	pass # Replace with function body.


func _on_area_3d_key(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and lighton and can_touch:
		$"../../DirectionalLight3D".visible=false
		$MeshInstance3D.visible=false
		$"../framelight".visible=false
		lighton=false
		$AudioStreamPlayer.play()
		can_touch = false
		cooldown_timer = 0.0
		
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not lighton and can_touch:
		$"../../DirectionalLight3D".visible=true
		$MeshInstance3D.visible=true
		$"../framelight".visible=true
		lighton=true
		can_touch = false
		cooldown_timer = 0.0
		$AudioStreamPlayer.play()
