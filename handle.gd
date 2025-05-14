extends Node3D
signal handtaken

# Constants for save data
const SAVE_FILE_PATH = "user://handel_save.dat"
var save_data = {}

# Variable to track if handle is taken
var handle_is_taken = false

func _ready():
	# Load saved data when the scene starts
	load_game()
	
	# Apply the loaded data
	if save_data.has("handle_is_taken"):
		handle_is_taken = save_data["handle_is_taken"]
		
	# Update visual state based on loaded data
	$".".visible = !handle_is_taken

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		$".".visible = false
		handle_is_taken = true
		
		# Save state change
		save_game()
		
		emit_signal("handtaken")

# Save game data
func save_game():
	save_data = {
		"handle_is_taken": handle_is_taken
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
			"handle_is_taken": false
		}

# Reset function to be called from the reset button
func reset_game():
	# Reset variables to default state
	handle_is_taken = false
	
	# Reset visual state
	$".".visible = true
	
	# Save the reset state
	save_game()
