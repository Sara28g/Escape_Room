extends Node3D
signal sceneover
signal closejoystick
signal closelabel
signal j2
var onceopen = false

# Save file path
const SAVE_PATH = "user://color_puzzle_save.dat"
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
# Available colors (Rubik's Cube colors)
var color_options = [
	Color(1, 1, 1),       # White (moved to first position)
	Color(1, 0, 0),       # Red
	Color(0, 0, 1),       # Blue
	Color(1, 0.5, 0),     # Orange
	Color(0, 0.5, 0),     # Darker Green (changed from 1.0 to 0.5)
	Color(1, 1, 0)        # Yellow
]
# Current color index for each button - all start at 0 (white)
var current_color_indices = [0, 0, 0, 0, 0, 0]
# Reference to the button meshes and areas
var button_meshes = []
var button_areas = []
# Signal to emit when all buttons have specific colors
signal correct_combination
# Define the correct combination using indices instead of custom colors
var correct_indices = [4, 3, 4, 5, 1, 2]  # Green, Orange, Green, Yellow, Red, Blue

func _ready():
	# Get references to all button meshes (parents)
	button_meshes = [
		$led/b1,
		$led/b2,
		$led/b3,
		$led/b4,
		$led/b5,
		$led/b6,
	]
	
	# Get references to the Area3D children
	button_areas = []
	for i in range(button_meshes.size()):
		button_areas.append(button_meshes[i].get_node("Area3D"))
		
		# Connect the Area3D input_event signal
		button_areas[i].input_event.connect(_on_Button_input_event.bind(i))
	
	# Load saved game state
	load_game()
	
	# Initialize button colors based on loaded state
	for i in range(button_meshes.size()):
		_update_button_color(i)
		
	# If puzzle was already solved, update visual state
	if onceopen:
		update_solved_state()

# This function will be called when any button receives an input event
func _on_Button_input_event(_camera, event, _position, _normal, _shape_idx, button_index):
	# Check if the button was clicked with left mouse button
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and onceopen == false and can_touch :
		# Cycle to the next color for this button
		current_color_indices[button_index] = (current_color_indices[button_index] + 1) % color_options.size()			
		# Update the button's color
		_update_button_color(button_index)
		$AudioStreamPlayer3D2.play()
		can_touch = false
		cooldown_timer = 0.0
		# Check if the puzzle is solved
		_check_solution()
		# Save game state after button press
		save_game()

func _update_button_color(button_index):
	# Get the MeshInstance3D (parent)
	var mesh_instance = button_meshes[button_index]
	var color_index = current_color_indices[button_index]
	var new_color = color_options[color_index]
	
	# Update the material of the button
	var material = StandardMaterial3D.new()
	material.albedo_color = new_color
	material.metallic = 0.2
	material.roughness = 0.4
	mesh_instance.material_override = material

func _check_solution():
	# Check if all buttons have the correct color index
	var all_correct = true
	for i in range(button_meshes.size()):
		if current_color_indices[i] != correct_indices[i]:
			all_correct = false
			break
	
	if all_correct:
		# Emit a signal that your box opening code can connect to
		emit_signal("correct_combination")
		print("Correct combination! Box should open.")
		$AnimationPlayer.play("open_box")
		$AudioStreamPlayer3D.play()
		onceopen = true
		$j2/rise.play("rise")
		$AudioStreamPlayer.play()
		$"../../Control/Control/Panel".visible = true
		emit_signal("closelabel")
		$"../../Control/Control/Panel/Label".text = "collect jewel"
		# Save game state after solving puzzle
		save_game()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		$j2.visible = false
		emit_signal("j2")
		# Save game state after collecting jewel
		save_game()

func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick")

func _on_close_sceneover() -> void:
	emit_signal("sceneover")

# Save game data
func save_game():
	var save_data = {
		"onceopen": onceopen,
		"current_color_indices": current_color_indices,
		"jewel_collected": !$j2.visible  # Track if jewel is collected
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
		onceopen = save_data.get("onceopen", false)
		
		# Load color indices with fallback to default
		var saved_indices = save_data.get("current_color_indices", [0, 0, 0, 0, 0, 0])
		for i in range(min(saved_indices.size(), current_color_indices.size())):
			current_color_indices[i] = saved_indices[i]
			
		# Handle jewel visibility
		if save_data.get("jewel_collected", false):
			$j2.visible = false
		else:
			$j2.visible = !onceopen  # Only show if box is open but jewel not collected

# Update the visual state to match a solved puzzle
func update_solved_state():
	# If the animation exists, set it to the end state
	if $AnimationPlayer.has_animation("open_box"):
		$AnimationPlayer.play("open_box")
		$AnimationPlayer.seek($AnimationPlayer.current_animation_length, true)
	
	# If the jewel hasn't been collected yet, make sure it's in the right position
	if $j2.visible:
		if $j2/rise.has_animation("rise"):
			$j2/rise.play("rise")
			$j2/rise.seek($j2/rise.current_animation_length, true)

# Reset function to connect to a button
func reset_game():
	# Reset all variables
	onceopen = false
	current_color_indices = [0, 0, 0, 0, 0, 0]
	
	# Reset visual state
	for i in range(button_meshes.size()):
		_update_button_color(i)
	
	# Reset animations
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
		
	if $j2/rise.is_playing():
		$j2/rise.stop()
	
	# Reset box to closed state
	# This will depend on your specific scene structure
	# You might need to add code to restore the initial box state
	
	# Reset jewel visibility
	$j2.visible = true
	
	# Reset UI elements
	$"../../Control/Control/Panel".visible = false
	
	# Save the reset state
	save_game()
