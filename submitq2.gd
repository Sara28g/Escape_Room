extends Button
signal sceneover
signal closejoystick
signal traingo
signal stop1

var once = true
var one = false
var two = false
var save_path = "user://line_puzzle_save.dat"
var puzzle_solved = false
var stage_one_complete = false

@onready var line = $"../q1/Line2D"
@onready var line_edit = $"../Control/LineEdit" # Adjust path if needed
var correct_end_point = Vector2(920, 176)  # Target position
var position_tolerance = 12 # Allowed margin

func _ready():
	self.pressed.connect(_on_submit_pressed)
	load_puzzle_state()
	
	# Update UI based on saved state
	if stage_one_complete:
		one = true
		$"../q1".visible = false
		$"../Control".visible = true
		emit_signal("stop1")
	
	if puzzle_solved:
		# Puzzle completely solved
		disabled = true
		$"../Label".text = "✅ Already Solved"
		once = false

func _on_submit_pressed():
	if puzzle_solved:
		return
		
	if one == false:
		check_end_point()
	else:
		check_ans()

func check_end_point():
	if line.points.size() < 2:
		print("Line not drawn correctly.")  # Ensure at least two points exist
		return
	var player_end_point = line.points[-1]  # Get the last point of the line
	if player_end_point.distance_to(correct_end_point) < position_tolerance:
		print("✅ Correct position!")
		$"../Label".text = "✅ Correct"
		one = true
		stage_one_complete = true
		save_puzzle_state()
		
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		$"../q1".visible = false
		$"../Control".visible = true
		$"../Label".text = ""
		emit_signal("stop1")
		show_feedback(true)
	else:
		$"../Label".text = "❌ Incorrect"
		print("❌ Incorrect position.")
		show_feedback(false)
		
func is_answer_close(input_text: String, correct_answer: float, tolerance: float) -> bool:
	var user_input = float(input_text)  # Convert the input to a float
	return abs(user_input - correct_answer) <= tolerance

func check_ans():
	var correct_answer = 97.96
	var tolerance = 0.96
	var user_input_text = line_edit.text  # Get text from LineEdit
	
	if user_input_text.is_valid_float():  # Check if input is a valid number
		if is_answer_close(user_input_text, correct_answer, tolerance) and once:
			print("✅ Correct")
			once = false
			puzzle_solved = true
			disabled = true  # Disable the submit button
			save_puzzle_state()
			
			$"../Label".text = "✅ Correct"
			await get_tree().process_frame
			await get_tree().create_timer(2.0).timeout
			show_feedback(true)
			emit_signal("traingo")
			emit_signal("closejoystick")
			$"..".visible = false  # Replace with UI feedback
		else:
			if once:
				$"../Label".text = "❌ Incorrect"
				print("❌ Incorrect.")
				show_feedback(false)
	else:
		if once:
			$"../Label".text = "Invalid input, please enter a number"
			print("Invalid input, please enter a number.")

func show_feedback(correct: bool):
	if correct:
		print("Well done!")  # Replace with a UI change if needed
	else:
		print("Try again.")  # Replace with a UI change if needed

# Save the puzzle state
func save_puzzle_state():
	var save_data = {
		"puzzle_solved": puzzle_solved,
		"stage_one_complete": stage_one_complete
	}
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		print("Line puzzle state saved")
	else:
		print("Error saving line puzzle state")

# Load the puzzle state
func load_puzzle_state():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			puzzle_solved = save_data.get("puzzle_solved", false)
			stage_one_complete = save_data.get("stage_one_complete", false)
			print("Line puzzle state loaded, solved: ", puzzle_solved, ", stage one: ", stage_one_complete)
		else:
			print("Error loading line puzzle state")
	else:
		print("No saved line puzzle state found")

# Reset function that can be called from outside
func reset_puzzle():
	puzzle_solved = false
	stage_one_complete = false
	one = false
	once = true
	disabled = false
	save_puzzle_state()
	
	# Reset UI elements
	$"../Label".text = ""
	$"../q1".visible = true
	$"../Control".visible = false
	
	# Clear the line
	if line.points.size() > 0:
		line.clear_points()
	
	# Clear the line edit
	if line_edit:
		line_edit.text = ""
	
	print("Line puzzle reset")
