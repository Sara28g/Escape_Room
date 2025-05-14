extends Node3D
signal sceneover
signal closejoystick
signal closecam
var camcanopen = false
signal open1
signal open2

# Save file path
const SAVE_PATH = "user://camera_save.dat"

func _ready() -> void:
	# Load saved state
	load_game()

func _on_curtains_closecam() -> void:
	camcanopen = false
	emit_signal("closecam")
	save_game()

func _on_curtains_opencam() -> void:
	camcanopen = true
	emit_signal("closecam")  # First close any existing camera view
	save_game()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and camcanopen:
		emit_signal("open1")
		emit_signal("closejoystick")
		save_game()
		
func _on_area_3d_2_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and camcanopen:
		emit_signal("open2")
		emit_signal("closejoystick")

		save_game()
		
func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick")
	save_game()

func _on_close_sceneover() -> void:
	emit_signal("sceneover")
	save_game()

# Save game data
func save_game():
	var save_data = {
		"camcanopen": camcanopen
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
		camcanopen = save_data.get("camcanopen", false)

# Reset function to connect to a button
func reset_game():
	# Reset camera state
	camcanopen = false
	
	# Close any open cameras
	emit_signal("closecam")

	# Save the reset state
	save_game()
