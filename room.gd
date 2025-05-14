extends Node3D

signal openhall
signal cams

func _on_table_j_gameover() -> void:
	emit_signal("cams")
	$AudioStreamPlayer.play()
	$opendoor.play("open door")
	await get_tree().create_timer(4.0).timeout  # Stop after 2 seconds
	emit_signal("openhall")
	await get_tree().create_timer(10.0).timeout
	$"../iteams/tableJ/Camera3D3/AnimationPlayer".play("camgo")
	await get_tree().create_timer(2.0).timeout  # Stop after 2 seconds
	$AudioStreamPlayer3.play()
 # Replace with function body.
