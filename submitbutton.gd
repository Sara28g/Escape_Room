extends Button
signal connect_to

@onready var minute_handle = $"../Panel/handel2"
@onready var hour_handle = $"../Panel/handel1"
@onready var sec_handle = $"../Panel/handel3"

var save_path = "user://clock_puzzle_save.dat"
var puzzle_solved = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("works")
	load_puzzle_state()
	# If already solved, update UI accordingly and disable this button
	if puzzle_solved:
		$"../Label".text = "✅ Already Solved"
		disabled = true  # Disables the submit button itself

func _on_pressed():
	correct()
	
func correct():
	# If already solved, don't check again
	if puzzle_solved:
		return
		
	var minr = fmod(minute_handle.rotation, 360)
	var secr = fmod(sec_handle.rotation, 360)
	var hourr = fmod(hour_handle.rotation, 360)
	
	var tolerance = 0.02
	var tolerance2 = 0.005
	var tolerance3 = 0.05
	
	if (abs(minr - (3.14113068580627)) <= tolerance or abs(minr + (3.14113068580627)) <= tolerance) and (abs(hourr - (2.62092542648315)) <= tolerance3 or abs(hourr + (2.62092542648315)) <= tolerance3) and (abs(secr - (-0.00318565079942)) <= tolerance2 or abs(secr + (-0.00318565079942)) <= tolerance2):
		$"../Label".text = "✅ Correct"
		puzzle_solved = true
		disabled = true  # Disable the submit button
		save_puzzle_state()
		
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		emit_signal("connect_to")
		$"..".visible = false
	else:
		$"../Label".text = "❌ Incorrect"
		print("wrong")

# Save the puzzle state
func save_puzzle_state():
	var save_data = {
		"puzzle_solved": puzzle_solved
	}
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		print("Clock puzzle state saved")
	else:
		print("Error saving clock puzzle state")

# Load the puzzle state
func load_puzzle_state():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			puzzle_solved = save_data.get("puzzle_solved", false)
			print("Clock puzzle state loaded, solved: ", puzzle_solved)
		else:
			print("Error loading clock puzzle state")
	else:
		print("No saved clock puzzle state found")

# Reset function that can be called from outside
func reset_puzzle():
	puzzle_solved = false
	disabled = false  # Re-enable the submit button
	save_puzzle_state()
	$"../Label".text = ""
	
	# Reset handles to initial positions
	minute_handle.rotation = 0
	hour_handle.rotation = 0
	sec_handle.rotation = 0
	
	print("Clock puzzle reset")
