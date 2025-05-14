extends Node3D

signal reset
signal sceneover
signal closejoystick
signal closelabel
signal dco
signal close
signal closecams
var once=true
var num=0

# Save data constants
const SAVE_FILE_PATH = "user://game_save.dat"
var save_data = {}

func _ready():
	load_game()

# Save data functions
func save_game():
	var data_to_save = {
		"once": once,
		"num": num,
		"scene_state": get_scene_state()
	}
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(data_to_save)
	else:
		print("Error saving game data")

func load_game():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			save_data = file.get_var()
			apply_saved_data()
		else:
			print("Error loading game data")

func apply_saved_data():
	# Safely get values with fallbacks
	if save_data.has("once"):
		once = save_data["once"]
	
	if save_data.has("num"):
		num = save_data["num"]
	
	# Apply scene state if it exists
	if save_data.has("scene_state"):
		apply_scene_state(save_data["scene_state"])

func get_scene_state():
	# Collect any additional state you want to save
	var state = {}
	
	# Safely access nodes and their properties
	if has_node("../../Control/Control/Panel"):
		state["panel_visible"] = $"../../Control/Control/Panel".visible
		
		if has_node("../../Control/Control/Panel/Label"):
			state["panel_text"] = $"../../Control/Control/Panel/Label".text
	
	if has_node("../../Control/qs3"):
		state["qs3_visible"] = $"../../Control/qs3".visible
	
	return state

func apply_scene_state(state):
	# Safely apply state values
	if state.has("panel_visible") and has_node("../../Control/Control/Panel"):
		$"../../Control/Control/Panel".visible = state["panel_visible"]
	
	if state.has("panel_text") and has_node("../../Control/Control/Panel/Label"):
		$"../../Control/Control/Panel/Label".text = state["panel_text"]
	
	if state.has("qs3_visible") and has_node("../../Control/qs3"):
		$"../../Control/qs3".visible = state["qs3_visible"]

# Reset game function - connect this to your reset button
func reset_game():
	once = true
	num = 0
	emit_signal("reset")
	if has_node("../../Control/Control/Panel"):
		$"../../Control/Control/Panel".visible = false
	
	if has_node("../../Control/qs3"):
		$"../../Control/qs3".visible = false
	
	save_game()
	emit_signal("sceneover")

func _on_qs_3_opendrawer() -> void:
	emit_signal("dco")
	save_game()

func _on_c_3_label() -> void:
	$"../../Control/Control/Panel".visible = true
	emit_signal("closelabel")
	$"../../Control/Control/Panel/Label".text = "locked"
	save_game()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and once:
		once = false
		print("once")
		save_game()
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not once:
		$"../../Control/qs3".visible = true
		print("twice")
		save_game()

func _on_close_sceneover() -> void:
	once = true
	emit_signal("sceneover")
	save_game()

func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick")

func _on_mirror_close() -> void:
	emit_signal("close")
	save_game()

func _on_camera_3d_closebuttons() -> void:
	emit_signal("closecams")
