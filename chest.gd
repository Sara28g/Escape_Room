extends Node3D
signal closelabel
signal j1
var key_took = false
var once = true
var once2 = true
var jewel_collected = false  # New variable to track jewel collection



# Save file path
const SAVE_PATH = "user://chest_save.dat"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	# First set default visual state
	set_closed_chest_state()
	# Then load game data if exists
	load_game()
	
func set_closed_chest_state():
	# Default closed chest state
	$treasureBox.visible = true
	$treasureBox_lock.visible = false
	$treasureBox_base.visible = false
	$treasureBox_lid.visible = false
	
func set_open_chest_state():
	# Opened chest state
	$treasureBox.visible = false
	$treasureBox_lock.visible = true
	$treasureBox_base.visible = true
	$treasureBox_lid.visible = true
	
func _on_key_key_t() -> void:
	key_took = true
	save_game()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if once and key_took == true and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		once = false
		print("Chest opened")
		$AnimationPlayer.play("Take 001")
		await get_tree().process_frame
		$j1.visible=true
		$j1/rise.play("rise")
		$AudioStreamPlayer3D.play()
		$"../../Control/Control/Panel".visible = true
		emit_signal("closelabel")
		$"../../Control/Control/Panel/Label".text = "collect jewel"
		await get_tree().process_frame
		await get_tree().create_timer(2.2).timeout
		
		# Set chest to open state
		set_open_chest_state()
		
		$AudioStreamPlayer3D2.play()
		await get_tree().create_timer(3.0).timeout
		$AudioStreamPlayer3D2.stop()
		$AudioStreamPlayer.play()
		save_game()
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and once:
		$"../../Control/Control/Panel".visible = true
		emit_signal("closelabel")
		$"../../Control/Control/Panel/Label".text = "missing a key"
		$AudioStreamPlayer2.play()
		await get_tree().create_timer(0.4).timeout 
		$AudioStreamPlayer2.stop()

func _on_j_1_j_1_t() -> void:
	emit_signal("j1")
	jewel_collected = true  # Set jewel as collected
	$j1.visible = false     # Hide the jewel
	save_game()

# Save game data
func save_game():
	var save_data = {
		"key_took": key_took,
		"once": once,
		"once2": once2,
		"chest_opened": !$treasureBox.visible,  # Track if chest has been opened
		"jewel_collected": jewel_collected      # Track if jewel has been collected
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
		key_took = save_data.get("key_took", false)
		once = save_data.get("once", true)
		once2 = save_data.get("once2", true)
		jewel_collected = save_data.get("jewel_collected", false)
		
		# Handle chest state
		if save_data.get("chest_opened", false):
			set_open_chest_state()
			
			# Set animations to correct state if chest is open
			if !once:
				# Skip animations to end state
				if $AnimationPlayer.has_animation("Take 001"):
					$AnimationPlayer.play("Take 001")
					$AnimationPlayer.seek($AnimationPlayer.current_animation_length, true)
					
				if $j1/rise.has_animation("rise"):
					$j1/rise.play("rise")
					$j1/rise.seek($j1/rise.current_animation_length, true)
		else:
			set_closed_chest_state()
			
		# Handle jewel visibility based on saved state
		if jewel_collected:
			$j1.visible = false
		else:
			# Only show jewel if chest is open
			$j1.visible = save_data.get("chest_opened", false)

# Reset function to connect to a button
func reset_game():
	# Reset all variables
	key_took = false
	once = true
	once2 = true
	jewel_collected = false
	
	# Reset visual state to closed chest
	set_closed_chest_state()
	
	# Reset jewel visibility
	$j1.visible = true  # Start with jewel hidden
	
	# Reset animations if needed
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	
	if $j1/rise.is_playing():
		$j1/rise.stop()
	
	# Reset UI elements
	$"../../Control/Control/Panel".visible = false
	
	# Save the reset state
	save_game()
