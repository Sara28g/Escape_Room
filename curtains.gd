extends Node3D
signal opencam
signal closecam
var open = false

# Save file path
const SAVE_PATH = "user://curtains_save.dat"
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
func _ready() -> void:
	$"vip-curtains".visible = true
	$"vip-curtains2".visible = false  # Ensure this is false by default
	
	# Load saved state
	load_game()
	
	# Update visual state based on loaded data
	update_visual_state()

func _on_cuetains_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if not open and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and can_touch:
		print("cur")
		open = true
		$AnimationPlayer2.play("open-full")
		$AudioStreamPlayer.play()
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer2.pause()
		$"vip-curtains".visible = false
		$"vip-curtains2".visible = true
		$cuetainsArea/CollisionShape3D3.visible = true
		$cuetainsArea/CollisionShape3D2.visible = true
		$cuetainsArea/CollisionShape3D.visible = false
		emit_signal("opencam")
		save_game()
		can_touch = false
		cooldown_timer = 0.0
		
	elif open and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and can_touch:
		open = false
		$AnimationPlayer2.play("open-full")
		$AnimationPlayer2.seek(5)
		$AudioStreamPlayer.play()
		$"vip-curtains".visible = true
		$"vip-curtains2".visible = false
		$cuetainsArea/CollisionShape3D3.visible = false
		$cuetainsArea/CollisionShape3D2.visible = false
		$cuetainsArea/CollisionShape3D.visible = true
		emit_signal("closecam")
		save_game()
		can_touch = false
		cooldown_timer = 0.0

# Save game data
func save_game():
	var save_data = {
		"open": open
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()

# Load game data
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		
		# Load saved values
		open = save_data.get("open", false)

# Update visual state based on loaded data
func update_visual_state():
	if open:
		# Set curtains to open state
		$"vip-curtains".visible = false
		$"vip-curtains2".visible = true
		$cuetainsArea/CollisionShape3D3.visible = true
		$cuetainsArea/CollisionShape3D2.visible = true
		$cuetainsArea/CollisionShape3D.visible = false
		
		# Set animation to correct state
		if $AnimationPlayer2.has_animation("open-full"):
			$AnimationPlayer2.play("open-full")
			$AnimationPlayer2.seek(2.0, true)  # Skip to paused position
			$AnimationPlayer2.pause()
	else:
		# Set curtains to closed state
		$"vip-curtains".visible = true
		$"vip-curtains2".visible = false
		$cuetainsArea/CollisionShape3D3.visible = false
		$cuetainsArea/CollisionShape3D2.visible = false
		$cuetainsArea/CollisionShape3D.visible = true

# Reset function to connect to a button
func reset_game():
	# Reset all variables
	open = false
	
	# Reset visual state
	$"vip-curtains".visible = true
	$"vip-curtains2".visible = false
	$cuetainsArea/CollisionShape3D3.visible = false
	$cuetainsArea/CollisionShape3D2.visible = false
	$cuetainsArea/CollisionShape3D.visible = true
	
	# Reset animation if needed
	if $AnimationPlayer2.is_playing():
		$AnimationPlayer2.stop()
	
	# Emit signal to ensure camera resets if needed
	emit_signal("closecam")
	
	# Save the reset state
	save_game()
