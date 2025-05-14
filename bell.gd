extends Node3D

signal b1
signal b2
signal b3
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
	if  (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and can_touch:
		print("b1")
		emit_signal("b1")
		$Sketchfab_model/AnimationPlayer.play("Take 001")
		$"../AudioStreamPlayer".play()
		can_touch = false
		cooldown_timer = 0.0

func _on_area_3d_2_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and can_touch:
		print("b2")
		emit_signal("b2")
		$Sketchfab_model/AnimationPlayer.play("Take 001")
		$"../AudioStreamPlayer".play()
		can_touch = false
		cooldown_timer = 0.0


func _on_area_3d_3_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and can_touch:
		print("b3")
		emit_signal("b3")
		$Sketchfab_model/AnimationPlayer.play("Take 001")
		$"../AudioStreamPlayer".play()
		can_touch = false
		cooldown_timer = 0.0
		 # Replace with function body.
