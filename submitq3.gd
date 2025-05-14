extends Button
signal opendrawer

@onready var line_edit = $"../Control/LineEdit" # Adjust path if needed
var save_path = "user://drawer_puzzle_save.dat"
var puzzle_solved = false

# In _ready() function, connect the signal if not done in the editor and load saved state
func _ready():
	if not is_connected("pressed", check_ans):
		connect("pressed", check_ans)
	
	load_puzzle_state()
	
	# If already solved, update UI and hide the entire panel
	if puzzle_solved:
		disabled = true
		$"../Label".text = "✅ Already Solved"     
		# This fixes the issue - immediately hide the parent control
		$"..".visible = false
	
# Make sure this function is connected to the button's pressed signal
func check_ans():
	# Skip checking if already solved
	if puzzle_solved:
		return
		
	var user_input_text = line_edit.text  # Get text from LineEdit
	
	if user_input_text.is_valid_float():  # Check if input is a valid number
		var user_input_float = float(user_input_text)  # Convert string to float
		
		if user_input_float == 0:  # Now compare numbers correctly
			print("✅ Correct")
			$"../Label".text = "✅ Correct"
			
			# Mark puzzle as solved and save state
			puzzle_solved = true
			disabled = true  # Disable button
			save_puzzle_state()
			
			await get_tree().process_frame
			await get_tree().create_timer(2.0).timeout
			emit_signal("opendrawer")
			$"..".visible = false  # Hide parent node
		else:
			$"../Label".text = "❌ Incorrect"
			print("❌ Incorrect.")
	else:
		$"../Label".text = "Invalid input, please enter a number"
		print("Invalid input, please enter a number.")

# Save the puzzle state
func save_puzzle_state():
	var save_data = {
		"puzzle_solved": puzzle_solved
	}
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		print("Drawer puzzle state saved")
	else:
		print("Error saving drawer puzzle state")

# Load the puzzle state
func load_puzzle_state():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			puzzle_solved = save_data.get("puzzle_solved", false)
			print("Drawer puzzle state loaded, solved: ", puzzle_solved)
		else:
			print("Error loading drawer puzzle state")
	else:
		print("No saved drawer puzzle state found")

# Reset function that can be called from outside
func reset_puzzle():
	puzzle_solved = false
	disabled = false
	save_puzzle_state()
	
	# Reset UI elements
	$"../Label".text = ""
	
	# Clear the line edit
	if line_edit:
		line_edit.text = ""
	
	print("Drawer puzzle reset")
