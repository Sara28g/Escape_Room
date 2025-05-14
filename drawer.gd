extends Node3D
signal label
var canopen = false
var open = false

# Constants for save data
const SAVE_FILE_PATH = "user://drawerbed_save.dat"
var save_data = {}
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
# Called when the node enters the scene tree for the first time.
func _ready():
	# Load saved data when the scene starts
	load_game()
	
	# Apply the loaded data to our variables
	if save_data.has("canopen"):
		canopen = save_data["canopen"]
	if save_data.has("open"):
		open = save_data["open"]
		
	# Update visual state based on loaded data
	if open:
		# Use call_deferred to ensure the animation is played after the scene is fully loaded
		call_deferred("_update_visual_state")

func _update_visual_state():
	if open:
		# Skip the animation and set to final state
		$"../../AnimationPlayer".play("open")
		$"../../AnimationPlayer".seek(1.0, true)
		$"../../AnimationPlayer".pause()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and open==false and canopen and can_touch:
		$"../../AnimationPlayer".play("open")
		$"../../AudioStreamPlayer3D".play()
		open = true
		can_touch = false
		cooldown_timer = 0.0
		save_game()  # Save after state change
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and open==true and canopen and can_touch:
		$"../../AnimationPlayer".play("close")
		$"../../AudioStreamPlayer3D".play()
		open = false
		can_touch = false
		cooldown_timer = 0.0
		save_game()  # Save after state change
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not canopen:
		emit_signal("label")
		$"../../AudioStreamPlayer3".play()
		await get_tree().create_timer(0.4).timeout 
		$"../../AudioStreamPlayer3".stop()
		can_touch = false
		cooldown_timer = 0.0

func _on_bedding_drawercanopen() -> void:
	canopen = true
	$"../../AnimationPlayer".play("open")
	$"../../AudioStreamPlayer3D".play()
	open = true
	save_game()  # Save after state change

# Save game data
func save_game():
	save_data = {
		"canopen": canopen,
		"open": open
	}
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()

# Load game data
func load_game():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			save_data = file.get_var()
			file.close()
	else:
		# Default values if no save file exists
		save_data = {
			"canopen": false,
			"open": false
		}

# Reset function to be called from the reset button
func reset_game():
	# Reset all variables to default state
	canopen = false
	open = false
	
	# Reset visual state
	if $"../../AnimationPlayer".is_playing():
		$"../../AnimationPlayer".stop()
	
	# If drawer is open, close it
	if open:
		$"../../AnimationPlayer".play("close")
		$"../../AnimationPlayer".seek(1.0, true)
		$"../../AnimationPlayer".pause()
	
	# Save the reset state
	save_game()
