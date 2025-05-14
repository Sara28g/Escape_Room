extends Node3D

@warning_ignore("unused_signal")
signal tabelj
var b1 = 0
var b2 = 0
var b3 = 0
var puzzle_solved = false

# Expected sequence: [bell_index, num_rings]
var expected_sequence = [
	[0, 2],  # First bell needs to be rung 2 times
	[1, 3],  # Second bell needs to be rung 3 times
	[2, 5]   # Third bell needs to be rung 5 times
]

# Save data constants
const SAVE_FILE_PATH = "user://bell_puzzle_save.dat"
var save_data = {}

func _ready():
	print("Bell puzzle initialized")
	print("Current sequence: First bell 2 times, Second bell 3 times, Third bell 5 times")
	
	# Load saved data when the scene starts
	load_game()
	
	# Apply the loaded data to our variables
	if save_data.has("puzzle_solved"):
		puzzle_solved = save_data["puzzle_solved"]
	
	# If puzzle was previously solved, update the visual state
	if puzzle_solved:
		print("Puzzle already solved!")
		$"../tableJ".visible = true
		$Camera3D.current = false
		$Camera3D/Control.visible = false

func _on_bell_b_1() -> void:
	if puzzle_solved:
		return  # Don't process inputs if puzzle is already solved
	
	print("Bell 1 rung")
	ringB1()

func _on_bell_2_b_2() -> void:
	if puzzle_solved:
		return  # Don't process inputs if puzzle is already solved
		
	print("Bell 2 rung")
	ringB2()

func _on_bell_3_b_3() -> void:
	if puzzle_solved:
		return  # Don't process inputs if puzzle is already solved
		
	print("Bell 3 rung")
	ringB3()

func on_sequence_complete():
	print("Sequence completed successfully!")	
	# Your special action or event goes here
	
	# Visual feedback
	print("Puzzle solved! Reward unlocked!")

# Optional: Add a function to manually reset the puzzle
func reset_puzzle():
	print("Puzzle has been reset")
	puzzle_solved = false
	b1 = 0
	b2 = 0
	b3 = 0
	
	# Reset visual state
	$"../tableJ".visible = false
	$Camera3D.current = true
	$Camera3D/Control.visible = true
	
	# Save the reset state
	save_game()
	
# Call this function when restarting the game
func reset_game():
	print("Game is restarting, resetting puzzle state")
	puzzle_solved = false
	b1 = 0
	b2 = 0
	b3 = 0
	
	# Reset visual state
	$"../tableJ".visible = false
	$Camera3D.current = true
	$Camera3D/Control.visible = true
	
	# Delete the save file to ensure a fresh start
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var dir = DirAccess.open("user://")
		if dir:
			dir.remove(SAVE_FILE_PATH)
			print("Save file deleted successfully")
		else:
			print("Failed to access directory")
	
	# Reset save data
	save_data = {
		"puzzle_solved": false
	}
	
	print("Game reset complete")
	
func ringB1():
	if b1 > 2:
		print("wrong")
		b1 = 0
		b2 = 0
		b3 = 0
	else:
		b1 += 1
		print(b1)

func ringB2():
	if b2 > 5 or b1 != 2:
		print("wrong")
		b1 = 0
		b2 = 0
		b3 = 0
	else:
		b2 += 1
		print(b2)
		print(b1)

func ringB3():
	if b3 > 3 or b1 != 2 or b2 != 5:
		print("wrong")
		b1 = 0
		b2 = 0
		b3 = 0
		
	else:
		b3 += 1
		print(b3)
		
	if b3 == 3 and b1 == 2 and b2 == 5:
		print("right")
		puzzle_solved = true
		save_game()  # Save the solved state
		
		$"../tableJ".visible = true
		$Camera3D.current = false
		$Camera3D/Control.visible = false
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		emit_signal("tabelj")

func _on_camera_3d_2_closebuttons() -> void:
	pass # Replace with function body.

# Save game data
func save_game():
	save_data = {
		"puzzle_solved": puzzle_solved
	}
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("Game saved successfully")
	else:
		print("Failed to save game data")

# Load game data
func load_game():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			save_data = file.get_var()
			file.close()
			print("Game loaded successfully")
		else:
			print("Failed to load game data")
	else:
		# Default values if no save file exists
		save_data = {
			"puzzle_solved": false
		}
		print("No save file found, using default values")
