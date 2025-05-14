extends Node3D
signal opencam
signal closecam
signal label
var canopen=false
var open=false

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
# Save data constants
const SAVE_FILE_PATH = "user://drawer_save.dat"
var save_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("saveable")
	load_game()
	

# Save data functions
func save_game():
	var data_to_save = {
		"canopen": canopen,
		"open": open
	}
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(data_to_save)
	else:
		print("Error saving drawer data")

func load_game():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			save_data = file.get_var()
			apply_saved_data()
		else:
			print("Error loading drawer data")

func apply_saved_data():
	# Safely get values with fallbacks
	if save_data.has("canopen"):
		canopen = save_data["canopen"]
	
	if save_data.has("open"):
		open = save_data["open"]
		
		# Update visual state to match saved state
		if has_node("../../../AnimationPlayer"):
			if open:
				$"../../../AnimationPlayer".play("o5")
				$"../../../AnimationPlayer".seek(1.0, true)  # Go to end of animation
			else:
				$"../../../AnimationPlayer".play("c5")
				$"../../../AnimationPlayer".seek(1.0, true)  # Go to end of animation

# Reset game function - connect this to your reset button
func reset_game():
	canopen = false
	open = false
	
	if has_node("../../../AnimationPlayer"):
		$"../../../AnimationPlayer".play("c5")
		$"../../../AnimationPlayer".seek(1.0, true)  # Go to end of animation
	
	save_game()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if canopen and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and open==false and can_touch:
		$"../../../AnimationPlayer".play("o5")
		$"../../../../../AudioStreamPlayer3D".play()
		open=true
		can_touch = false
		cooldown_timer = 0.0
		save_game()
	elif canopen and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and open==true and can_touch:
		$"../../../AnimationPlayer".play("c5")
		$"../../../../../AudioStreamPlayer3D".play()
		open=false
		save_game()
		can_touch = false
		cooldown_timer = 0.0
	elif (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed and not open and can_touch:
		emit_signal("label")
		$AudioStreamPlayer.play()
		await get_tree().create_timer(0.4).timeout 
		$AudioStreamPlayer.stop()
		can_touch = false
		cooldown_timer = 0.0
		# No need to save here as state doesn't change

func _on_table_dco() -> void:
	emit_signal("closecam")
	emit_signal("opencam")
	canopen=true
	$"../../../AnimationPlayer".play("o5")
	$"../../../../../AudioStreamPlayer3D".play()
	open=true
	save_game()


func _on_table_reset() -> void:
	pass # Replace with function body.
