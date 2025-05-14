extends MeshInstance3D
signal key_t
var key_taken = false

# Constants for save data
const SAVE_FILE_PATH = "user://key_save.dat"

func _ready() -> void:
	print("ready")
	
	# Load saved data
	load_game()
	
	# Apply loaded data
	$".".visible = !key_taken
	
	# Play animation if key is visible
	if !key_taken:
		$key_fly.play("key_fly")

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not key_taken:
		print("Key taken")
		key_taken = true
		$".".visible = false
		emit_signal("key_t")
		
		# Save state after key is taken
		save_game()

# Save game data
func save_game():
	var save_data = {
		"key_taken": key_taken
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
			var save_data = file.get_var()
			file.close()
			
			# Apply loaded data
			if save_data.has("key_taken"):
				key_taken = save_data["key_taken"]

# Reset function to be called from the reset button
func reset_game():
	# Reset variables to default state
	key_taken = false
	
	# Reset visual state
	$".".visible = true
	
	# Reset animation
	$key_fly.play("key_fly")
	
	# Save the reset state
	save_game()
