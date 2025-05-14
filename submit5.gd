extends Button
@onready var line_edit = $"../Control/LineEdit"
signal q5correct
signal sceneover

var save_path = "user://q5_puzzle_save.dat"
var puzzle_solved = false

func is_answer_close(input_text: String, correct_answer: float, tolerance: float) -> bool:
	var user_input = float(input_text)  # Convert the input to a float
	return abs(user_input - correct_answer) <= tolerance

func _ready():
	# Make sure the button is connected to the check_ans() function
	connect("pressed", check_ans)
	
	# Load saved state
	load_puzzle_state()
	
	# If already solved, update UI and disable button
	if puzzle_solved:
		disabled = true
		$"../Label".text = "✅ Already Solved"

func check_ans():
	# Skip checking if already solved
	if puzzle_solved:
		return
		
	var correct_answer = 12.5
	var tolerance = 0.1
	var user_input_text = line_edit.text  # Get text from LineEdit
	
	print("Button pressed. Input text: ", user_input_text)  # Debug print
	
	if user_input_text.is_valid_float():  # Check if input is a valid number
		var user_input = float(user_input_text)
		print("Converted input: ", user_input)  # Debug print
		
		if is_answer_close(user_input_text, correct_answer, tolerance):
			print("✅ Correct")
			$"../Label".text = "✅ Correct"
			
			# Mark puzzle as solved and save state
			puzzle_solved = true
			disabled = true  # Disable button
			save_puzzle_state()
			
			emit_signal("q5correct")
			await get_tree().process_frame
			await get_tree().create_timer(2.0).timeout
			emit_signal("sceneover")
			$"..".visible = false  # Replace with UI feedback
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
		print("Q5 puzzle state saved")
	else:
		print("Error saving Q5 puzzle state")

# Load the puzzle state
func load_puzzle_state():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			puzzle_solved = save_data.get("puzzle_solved", false)
			print("Q5 puzzle state loaded, solved: ", puzzle_solved)
		else:
			print("Error loading Q5 puzzle state")
	else:
		print("No saved Q5 puzzle state found")

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
	
	print("Q5 puzzle reset")
