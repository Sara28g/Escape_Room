extends Node3D
signal gameover
signal callfunc
signal closelabel
var tableopen = false
var j1 = false
var j2 = false
var j3 = false
var j4 = false
var j5 = false
var attach1 = false
var attach2 = false
var attach3 = false
var attach4 = false
var attach5 = false
var onceopen = false

# Save file path
const SAVE_PATH = "user://game_save.dat"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector3(-0.2, -0.45, 0.0)
	load_game()

func _on_bells_tabelj() -> void:
	if not tableopen:
		emit_signal("callfunc")
		$AnimationPlayer.play("table_open")
		$"../../AudioStreamPlayer".play()
		await get_tree().create_timer(3).timeout
		$"../../AudioStreamPlayer".stop()
		tableopen = true
		save_game()
		
func _on_chest_j_1() -> void:
	j1 = true
	save_game()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if tableopen and (j1 or j2 or j3 or j4 or j5) and onceopen:
		$"../../Control/Control/Panel".visible = true
		emit_signal("closelabel")
		$"../../Control/Control/Panel/Label".text = "attach jewels"
		
	if tableopen and j1 and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not attach1 and onceopen:
		attach1 = true
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		$diamonds/j1/AnimationPlayer.play("j1_attach")
		$diamonds/j1.visible = true
		$AudioStreamPlayer2.play()
		j1 = false
		print("1")
		save_game()
		
	if tableopen and j2 and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not attach2 and onceopen:
		attach2 = true
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		$diamonds/j2/AnimationPlayer.play("j4_attach")
		$diamonds/j2.visible = true
		$AudioStreamPlayer2.play()
		j2 = false
		print("2")
		save_game()
		
	if tableopen and j3 and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not attach3 and onceopen:
		attach3 = true
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		$diamonds/j3/AnimationPlayer.play("j2_attach")
		$diamonds/j3.visible = true
		$AudioStreamPlayer2.play()
		j3 = false
		print("3")
		save_game()
	
	if tableopen and j4 and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not attach4 and onceopen:
		attach4 = true
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		$diamonds/j4/AnimationPlayer.play("j3_attach")
		$diamonds/j4.visible = true
		$AudioStreamPlayer2.play()
		j4 = false
		print("4")
		save_game()
			
	if tableopen and j5 and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not attach5 and onceopen:
		attach5 = true
		await get_tree().process_frame
		await get_tree().create_timer(2.0).timeout
		$diamonds/j5/AnimationPlayer.play("j5_attach")
		$diamonds/j5.visible = true
		$AudioStreamPlayer2.play()
		j5 = false
		print("5")
		save_game()
		
	if (attach1 and attach2 and attach3 and attach4 and attach5):
		await get_tree().create_timer(3.0).timeout
		$"../../WorldEnvironment".environment.background_color = Color.BLACK
		emit_signal("gameover")

func _on_box_j_2() -> void:
	j2 = true
	save_game()

func _on_train_j_3() -> void:
	j3 = true
	save_game()

func _on_bedding_j_4() -> void:
	j4 = true
	save_game()

func _on_tv_j_5() -> void:
	j5 = true
	save_game()

func _on_camera_3d_2_nodecall() -> void:
	onceopen = true
	save_game()

func _on_close_sceneover() -> void:
	onceopen = false
	save_game()

# Save game data
func save_game():
	var save_data = {
		"tableopen": tableopen,
		"j1": j1,
		"j2": j2,
		"j3": j3,
		"j4": j4,
		"j5": j5,
		"attach1": attach1,
		"attach2": attach2,
		"attach3": attach3,
		"attach4": attach4,
		"attach5": attach5,
		"onceopen": onceopen
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
		tableopen = save_data.get("tableopen", false)
		j1 = save_data.get("j1", false)
		j2 = save_data.get("j2", false)
		j3 = save_data.get("j3", false)
		j4 = save_data.get("j4", false)
		j5 = save_data.get("j5", false)
		attach1 = save_data.get("attach1", false)
		attach2 = save_data.get("attach2", false)
		attach3 = save_data.get("attach3", false)
		attach4 = save_data.get("attach4", false)
		attach5 = save_data.get("attach5", false)
		onceopen = save_data.get("onceopen", false)
		
		# Update visual state based on loaded data
		update_visual_state()

# Update the visual state of objects based on loaded data
func update_visual_state():
	if attach1:
		$diamonds/j1.visible = true
	if attach2:
		$diamonds/j2.visible = true
	if attach3:
		$diamonds/j3.visible = true
	if attach4:
		$diamonds/j4.visible = true
	if attach5:
		$diamonds/j5.visible = true
	
	if tableopen:
		# Make sure table appears in open state
		# You might need to adjust this depending on how your animation works
		$AnimationPlayer.play("table_open")
		$AnimationPlayer.seek(3.0, true) # Skip to end of animation

# Reset function to connect to a button
func reset_game():
	# Reset all variables
	tableopen = false
	j1 = false
	j2 = false
	j3 = false
	j4 = false
	j5 = false
	attach1 = false
	attach2 = false
	attach3 = false
	attach4 = false
	attach5 = false
	onceopen = false
	
	# Reset visual state
	$diamonds/j1.visible = false
	$diamonds/j2.visible = false
	$diamonds/j3.visible = false
	$diamonds/j4.visible = false
	$diamonds/j5.visible = false
	
	# Reset table if needed
	if $AnimationPlayer.has_animation("table_close"):
		$AnimationPlayer.play("table_close")
	
	# Save the reset state
	save_game()
	
	# Optional: Reset any other scene elements
	$"../../Control/Control/Panel".visible = false
	$"../../WorldEnvironment".environment.background_color = Color(1, 1, 1) # Default background color
