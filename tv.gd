extends Node3D
signal sceneover2
signal closejoystick
signal closelabel
signal j5
signal sceneover
# References to nodes
@onready var sub_viewport = $SubViewport
@onready var mesh_instance = $MeshInstance3D
@onready var video_player = $SubViewport/VideoStreamPlayer
var control_panel = null
var label = null
@onready var jewel = $j5
var has_played_tv := false
var has_collected_jewel := false
var save_path := "user://save_game.json"

func _ready():
	control_panel = get_node_or_null("../../Control/Control/Panel")
	label = get_node_or_null("../../Control/Control/Panel/Label")
	
	if control_panel == null:
		print("Error: Control panel node not found!")
	load_game()
	var material = StandardMaterial3D.new()
	material.albedo_texture = sub_viewport.get_texture()
	mesh_instance.material_override = material
	apply_game_state()

func _on_electronic_playtv() -> void:
	if has_played_tv:
		return 
	$Camera3D.current = true
	video_player.play()
	$Camera3D/Control.visible = true
	await get_tree().create_timer(2).timeout
	if not has_collected_jewel:
		jewel.visible = true
		$j5/rise.play("new_animation")
		if control_panel != null:
			control_panel.visible = true
			emit_signal("closelabel")
			label.text = "collect jewel"
	$AudioStreamPlayer.play()
	has_played_tv = true
	save_game()

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		if not has_collected_jewel:
			jewel.visible = false
			has_collected_jewel = true
			save_game()
			emit_signal("j5")
			print("collected j5")

func _on_camera_3d_closejoystick() -> void:
	emit_signal("closejoystick")

func _on_close_sceneover() -> void:
	emit_signal("sceneover2")

# ===============================
# Saving and Loading Funcs
func save_game():
	var save_data = {
		"has_played_tv": has_played_tv,
		"has_collected_jewel": has_collected_jewel
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func load_game():
	if not FileAccess.file_exists(save_path):
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	var result = JSON.parse_string(content)
	file.close()
	if result:
		has_played_tv = result.get("has_played_tv", false)
		has_collected_jewel = result.get("has_collected_jewel", false)

func apply_game_state():
	jewel.visible = has_played_tv and not has_collected_jewel
	if has_played_tv and not has_collected_jewel:
		if control_panel != null:
			control_panel.visible = true
			label.text = "collect jewel"
	else:
		if control_panel != null:
			control_panel.visible = false

func _on_reset_button_pressed():
	reset_game()

#reset the game
func reset_game():

	has_played_tv = false
	has_collected_jewel = false
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify({}))
	file.close()
	
	if jewel != null:
		jewel.visible = false
	
	if control_panel != null:
		control_panel.visible = false
		if label != null:
			label.text = ""
	
	get_tree().reload_current_scene()
