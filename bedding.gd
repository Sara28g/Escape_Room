extends Node3D
signal closelabel
signal j4
signal reset
signal drawercanopen
signal sceneover
signal closejoystick

# Constants for save data
const SAVE_FILE_PATH = "user://bedding_save.dat"
var save_data = {}

# Variables to track game state
var drawer_unlocked = false
var jewel_collected = false
var j4_visible = true  # Assuming this should be true by default

func _ready():
	# Load saved data when the scene starts
	load_game()
	
	# Apply the loaded data to our variables
	if save_data.has("drawer_unlocked"):
		drawer_unlocked = save_data["drawer_unlocked"]
	if save_data.has("jewel_collected"):
		jewel_collected = save_data["jewel_collected"]
	if save_data.has("j4_visible"):
		j4_visible = save_data["j4_visible"]
		
	# Update visual state based on loaded data
	$"music box/j4".visible = j4_visible

func _on_qs_5_correct_5() -> void:
	await get_tree().process_frame
	await get_tree().create_timer(2.0).timeout
	
	drawer_unlocked = true
	save_game()  # Save the state change
	
	emit_signal("drawercanopen")

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		$"music box/j4".visible = false
		j4_visible = false
		emit_signal("j4")
		save_game()  # Save the state change
		

func _on_music_box_closelabel() -> void:
	$"../../Control/Control/Panel".visible = true
	emit_signal("closelabel")
	$"../../Control/Control/Panel/Label".text = "something is missing"

func _on_drawer_label() -> void:
	$"../../Control/Control/Panel".visible = true
	emit_signal("closelabel")
	$"../../Control/Control/Panel/Label".text = "locked"

func _on_music_box_label_2() -> void:
	$"../../Control/Control/Panel".visible = true
	emit_signal("closelabel")
	$"../../Control/Control/Panel/Label".text = "collect jewel"
	
	jewel_collected = true
	save_game()  # Save when the jewel is collected

func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick")

func _on_close_sceneover() -> void:
	emit_signal("sceneover")

# Save game data
func save_game():
	save_data = {
		"drawer_unlocked": drawer_unlocked,
		"jewel_collected": jewel_collected,
		"j4_visible": j4_visible
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
			"drawer_unlocked": false,
			"jewel_collected": false,
			"j4_visible": true
		}

# Reset function to be called from the reset button
func reset_game():
	emit_signal("reset")
	# Reset all variables to default state
	drawer_unlocked = false
	jewel_collected = false
	j4_visible = true
	
	# Reset visual state
	$"music box/j4".visible = true
	
	# Reset UI elements if needed
	$"../../Control/Control/Panel".visible = false
	
	# Save the reset state
	save_game()
