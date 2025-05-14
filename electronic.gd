extends Node3D

signal sceneover
signal closejoystick
signal playtv
signal startpro
signal closec
signal reset 

func restart_game():
	emit_signal("reset")
# Pattern of correct switch states (true = on, false = off)
# Modify this array to match your desired correct pattern
var correct_pattern = [
	false, false, true,
	false, true, true,
	true, true, true,
	true, false, true
]

# Array to track the current state of each switch
var switch_states = []

# References to switch nodes
var switches = []

func _ready():
	# Initialize switch states (all off)

	for i in range(12):
		switch_states.append(false)
	
	# Get references to all switch nodes
	switches = [
		$Node3D/RootNode/cube1/c1,
		$Node3D/RootNode/cube1/c2,
		$Node3D/RootNode/cube1/c3,
		$Node3D/RootNode/cube2/c4,
		$Node3D/RootNode/cube2/c5,
		$Node3D/RootNode/cube2/c6,
		$Node3D/RootNode/cube3/c7,
		$Node3D/RootNode/cube3/c8,
		$Node3D/RootNode/cube3/c9,
		$Node3D/RootNode/cube4/c10,
		$Node3D/RootNode/cube4/c11,
		$Node3D/RootNode/cube4/c12
	]
	
	# Verify all switch references are valid
	for i in range(switches.size()):
		if switches[i] == null:
			print("Warning: Switch at index ", i, " is null!")
		else:
			# Connect to the switch's signal if it exists
			if switches[i].has_signal("switch_toggled"):
				switches[i].connect("switch_toggled", _on_switch_toggled)
			else:
				print("Warning: Switch ", i, " doesn't have switch_toggled signal")
	
	# Set up input processing
	set_process_input(true)
	
	print("Puzzle initialized with ", switches.size(), " switches")
	print("Correct pattern: ", correct_pattern)

# Handle when a switch node signals it's been toggled
func _on_switch_toggled(switch_node, is_open):
	# Find which switch was toggled
	var switch_index = -1
	for i in range(switches.size()):
		if switches[i] == switch_node:
			switch_index = i
			break
	
	if switch_index != -1:
		# Update our state
		switch_states[switch_index] = is_open
		print("Switch ", switch_index, " state updated to ", is_open)
		
		# Check if pattern is correct
		check_pattern()
	else:
		print("Warning: Switch node not found in switches array")

# Check if the current pattern matches the correct pattern
func check_pattern():
	print("Checking pattern...")
	print("Current states: ", switch_states)
	
	var is_correct = true
	for i in range(correct_pattern.size()):
		if i >= switch_states.size():
			print("Error: switch_states array too small")
			is_correct = false
			break
			
		if switch_states[i] != correct_pattern[i]:
			print("Mismatch at position ", i)
			is_correct = false
			break
	
	if is_correct:
		print("Correct!")
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		emit_signal("playtv")
		



		# Add your puzzle completion code here
		# For example:
		# $CompletionAnimation.play()
		# $RewardDoor.open()
	else:
		print("Not correct yet")

# For backwards compatibility or manual testing,
# you can still handle direct clicks in this script
func _input(event):
	# For mouse clicks
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_click(event.position)
	
	# For touch input
	elif event is InputEventScreenTouch and event.pressed:
		_handle_click(event.position)

# Handle click/touch at a position
func _handle_click(position):
	# Get the current camera
	var camera = get_viewport().get_camera_3d()
	if not camera:
		print("No camera found")
		return
		
	# Create ray from camera
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * 1000
	
	# Set up and perform raycast
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(ray_query)
	
	if result and result.has("collider"):
		var collider = result["collider"]
		print("Hit object: ", collider.name)
		
		# Check if the clicked object is one of our switches
		for i in range(switches.size()):
			if collider == switches[i]:
				print("Switch ", i, " clicked")
				toggle_switch(i)
				break

# Toggle a switch state
func toggle_switch(switch_index):
	# Toggle switch state
	switch_states[switch_index] = !switch_states[switch_index]
	print("Switch ", switch_index, " toggled to ", switch_states[switch_index])
	
	# Update the switch visual
	update_switch_visual(switch_index)
	
	# Check if pattern is correct
	check_pattern()

# Update the visual representation of a switch
func update_switch_visual(switch_index):
	var switch_node = switches[switch_index]
	
	# If the switch has its own animation handling, trigger it
	if switch_node.has_method("toggle"):
		switch_node.toggle()
	# Otherwise, use basic rotation
	else:
		if switch_states[switch_index]:
			# On state - rotate switch
			switch_node.rotation_degrees.z = 30
		else:
			# Off state
			switch_node.rotation_degrees.z = -30


func _on_qs_4_callelect() -> void:
	emit_signal("startpro") # Replace with function body.


func _on_object_5_openq_4() -> void:
	emit_signal("closejoystick")
	$"../../Control/qs4".visible=true # Replace with function body.




func _on_close_sceneover() -> void:
	emit_signal("sceneover") # Replace with function body.


func _on_tv_closeelec() -> void:
	emit_signal("closec") # Replace with function body.


func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick") # Replace with function body.
