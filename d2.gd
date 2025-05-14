extends Node3D


var open=false
# Called when the node enters the scene tree for the first time.
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
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and open==false and can_touch:
		$"../../../AnimationPlayer".play("o2")
		$"../../../../../AudioStreamPlayer3D".play()
		open=true
		can_touch = false
		cooldown_timer = 0.0
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and open==true and can_touch:
		$"../../../AnimationPlayer".play("c2")
		$"../../../../../AudioStreamPlayer3D".play()
		open=false
		can_touch = false
		cooldown_timer = 0.0
