extends Node3D
signal cam
signal j3
signal closelabel
signal sceneover
signal closejoystick

# Constants for save data
const SAVE_FILE_PATH = "user://jewel_scene_save.dat"

# Variables to track state
var jewel_taken = false
var sequence_played = false

func _ready() -> void:
	# Load saved data
	load_game()
	if !sequence_played:
		$"Sketchfab_model/0346359167ee43a7a2f6a687b5c0b6ea_fbx/Object_2/RootNode/S_Cart/j3".visible=false
	# Update visual state based on loaded data
	else:
		$"Sketchfab_model/0346359167ee43a7a2f6a687b5c0b6ea_fbx/Object_2/RootNode/S_Cart/j3".visible = !jewel_taken

func play():
	emit_signal("cam")
	emit_signal("closejoystick")
	
	if !sequence_played:
		sequence_played = true
		save_game()
	
	$Sketchfab_model/AnimationPlayer.play("Scene")
	$Sketchfab_model/AnimationPlayer.seek(2.98)
	$"Sketchfab_model/0346359167ee43a7a2f6a687b5c0b6ea_fbx/Object_2/RootNode/S_Cart/j3".visible=true
	$AudioStreamPlayer.play()
	await get_tree().create_timer(3).timeout
	$Sketchfab_model/AnimationPlayer.pause()
	$"../../Control/Control/Panel".visible = true
	emit_signal("closelabel")
	$"../../Control/Control/Panel/Label".text = "collect jewel"

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		emit_signal("j3")
		$"Sketchfab_model/0346359167ee43a7a2f6a687b5c0b6ea_fbx/Object_2/RootNode/S_Cart/j3".visible = false
		jewel_taken = true
		save_game()
		print("j3taken")

func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick")

func _on_close_sceneover() -> void:
	emit_signal("sceneover")

# Save game data
func save_game():
	var save_data = {
		"jewel_taken": jewel_taken,
		"sequence_played": sequence_played
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
			if save_data.has("jewel_taken"):
				jewel_taken = save_data["jewel_taken"]
			if save_data.has("sequence_played"):
				sequence_played = save_data["sequence_played"]

# Reset function to be called from the reset button
func reset_game():
	# Reset variables to default state
	jewel_taken = false
	sequence_played = false
	
	# Reset visual state
	$"Sketchfab_model/0346359167ee43a7a2f6a687b5c0b6ea_fbx/Object_2/RootNode/S_Cart/j3".visible = true
	
	# Stop animations if needed
	if $Sketchfab_model/AnimationPlayer.is_playing():
		$Sketchfab_model/AnimationPlayer.stop()
	
	# Save the reset state
	save_game()
