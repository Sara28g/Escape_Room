extends Node3D
signal sceneover
signal closejoystick

# Constants for save data
const SAVE_FILE_PATH = "user://clock_save.dat"

# Variables to track game state
var clock_opened = false
var key_visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ani")
	# Load saved data
	load_game()
	
	# Update visual state based on loaded data
	$Key.visible = key_visible
	if clock_opened:
		# Set the clock to its opened state without playing animation
		$clock_open.play("clock_open")
		$clock_open.seek(1.0, true) # Jump to end of animation

func _on_q_1_clock_opened() -> void:
	$Key.visible = true
	key_visible = true
	clock_opened = true
	print("key")
	$clock_open.play("clock_open")
	$AudioStreamPlayer.play()
	
	# Save state after changes
	save_game()
	
func _on_clock_a_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		print("in_clock_zone")
		emit_signal("closejoystick")
		$"../../Control/q_1".visible = true


func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick")

func _on_close_sceneover() -> void:
	emit_signal("sceneover")

# Save game data
func save_game():
	var save_data = {
		"clock_opened": clock_opened,
		"key_visible": key_visible
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
			if save_data.has("clock_opened"):
				clock_opened = save_data["clock_opened"]
			if save_data.has("key_visible"):
				key_visible = save_data["key_visible"]

# Reset function to be called from the reset button
func reset_game():
	# Reset variables to default state
	clock_opened = false
	key_visible = false
	
	# Reset visual state
	$Key.visible = false
	
	# Reset clock animation if needed
	if $clock_open.current_animation == "clock_open":
		$clock_open.stop()
	
	# Save the reset state
	save_game()
