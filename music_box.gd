extends Node3D

var handtakken = false
var once = true
signal label2
signal closelabel

# Add new variables to track save data
const SAVE_FILE_PATH = "user://musicbox_save.dat"
var save_data = {}

func _ready():
	# Load saved data when the scene starts
	load_game()
	
	# Apply the loaded data to our variables
	if save_data.has("handtakken"):
		handtakken = save_data["handtakken"]
	if save_data.has("once"):
		once = save_data["once"]
	if not once:
		$"../AnimationPlayer".play("play")
		$"../AnimationPlayer".seek(10.8)
		
	# Update visual state based on loaded data
	if !once:
		$Musicbox_handle_4.visible = true

func _on_handle_handtaken() -> void:
	handtakken = true
	save_game()  # Save whenever state changes

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and handtakken and once:
		once = false
		$Musicbox_handle_4.visible = true
		$"../AnimationPlayer".play("attach")
		$"../AnimationPlayer".play("play")
		$"../AudioStreamPlayer".play()
		await get_tree().create_timer(5).timeout
		$"../AudioStreamPlayer".stop()
		$"../AudioStreamPlayer2".play()
		await get_tree().create_timer(5).timeout
		$j4/rise.play("rise")
		$"../AudioStreamPlayer4".play()
		handtakken = false
		emit_signal("label2")
		save_game()  # Save after state changes
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not handtakken and once:
		emit_signal("closelabel")
		$"../AudioStreamPlayer3".play()
		await get_tree().create_timer(0.4).timeout
		$"../AudioStreamPlayer3".stop()

# Save game data
func save_game():
	save_data = {
		"handtakken": handtakken,
		"once": once
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
			"handtakken": false,
			"once": true
		}

# Reset function to connect to your reset button
func reset_game():
	# Reset all variables to default state
	handtakken = false
	once = true
	
	# Reset visual elements
	$Musicbox_handle_4.visible = false
	
	# Stop any ongoing animations/audio if necessary
	if $"../AnimationPlayer".is_playing():
		$"../AnimationPlayer".stop()
	if $"../AudioStreamPlayer".playing:
		$"../AudioStreamPlayer".stop()
	if $"../AudioStreamPlayer2".playing:
		$"../AudioStreamPlayer2".stop()
	if $"../AudioStreamPlayer3".playing:
		$"../AudioStreamPlayer3".stop()
	if $"../AudioStreamPlayer4".playing:
		$"../AudioStreamPlayer4".stop()
	
	# Save the reset state
	save_game()
