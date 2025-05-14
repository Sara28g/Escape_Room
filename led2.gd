extends MeshInstance3D

var open = false
var qs4correct = false
signal openq4

# Save file path
const SAVE_PATH = "user://doorelec_save.dat"

func _ready():
	# Load saved data when the scene starts
	load_data()

func on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and qs4correct:
		if open == false:
			$"../../../AnimationPlayer2".play("open")
			$"../../../opening".play()
			await get_tree().create_timer(0.5).timeout 
			$"../../../opening".stop()
			open = true
		else:
			$"../../../AnimationPlayer2".play("close")
			$"../../../opening".play()
			await get_tree().create_timer(0.5).timeout  
			$"../../../opening".stop()
			open = false
		# Save data after state changes
		save_data()
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not qs4correct:
		emit_signal('openq4')

func on_electronic_startpro() -> void:
	qs4correct = true
	print("elecopen")
	await get_tree().create_timer(3).timeout 
	$"../../../AnimationPlayer2".play("open")
	$"../../../opening".play()
	await get_tree().create_timer(0.5).timeout 
	$"../../../opening".stop()
	open = true
	# Save data after state changes
	save_data()

# Save the current state to a file
func save_data() -> void:
	var save_dict = {
		"open": open,
		"qs4correct": qs4correct
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_dict)
		print("Data saved successfully")
	else:
		print("Failed to save data")

# Load saved state from file
func load_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var data = file.get_var()
			open = data.get("open", false)
			qs4correct = data.get("qs4correct", false)
			
			# Update visual state if door was open when saved
			if open:
				$"../../../AnimationPlayer2".play("open")
				await get_tree().create_timer(0.1).timeout
				$"../../../AnimationPlayer2".stop()
			
			print("Data loaded successfully")
		else:
			print("Failed to load data")

# Reset function to clear progress
func reset_data() -> void:
	open = false
	qs4correct = false
	
	# Close the door if it's open
	if open:
		$"../../../AnimationPlayer2".play("close")
		$"../../../opening".play()
		await get_tree().create_timer(0.5).timeout
		$"../../../opening".stop()
	
	# Delete the save file
	if FileAccess.file_exists(SAVE_PATH):
		var dir = DirAccess.open("user://")
		if dir:
			dir.remove(SAVE_PATH)
	
	print("Data reset successfully")

# Public function that can be called from elsewhere
func reset() -> void:
	reset_data()
