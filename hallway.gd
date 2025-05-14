extends Node3D

func _on_room_openhall() -> void:
	
	$"../AudioStreamPlayer2".play()
	$OmniLight3D.visible=true
	await get_tree().create_timer(1.0).timeout  # Stop after 2 seconds

	$"../AudioStreamPlayer2".play()
	$OmniLight3D2.visible=true
	await get_tree().create_timer(1.0).timeout
	  # Stop after 2 seconds
	$"../AudioStreamPlayer2".play()
	$OmniLight3D3.visible=true
	await get_tree().create_timer(1.0).timeout
	
	$"../AudioStreamPlayer2".play()
	$OmniLight3D4.visible=true
	await get_tree().create_timer(1.0).timeout
	
	$"../AudioStreamPlayer2".play()
	$OmniLight3D5.visible=true
	await get_tree().create_timer(1.0).timeout
	
	$"../AudioStreamPlayer2".play()
	$OmniLight3D6.visible=true
	await get_tree().create_timer(1.0).timeout
	
	$"../AudioStreamPlayer2".play()
	$OmniLight3D7.visible=true
	await get_tree().create_timer(1.0).timeout
	
	$"../AudioStreamPlayer2".play()
	$OmniLight3D8.visible=true
	await get_tree().create_timer(1.0).timeout
	
	$"../AudioStreamPlayer2".play()
	$OmniLight3D9.visible=true
	$"../AudioStreamPlayer2".play()
	$OmniLight3D10.visible=true
	$"../AudioStreamPlayer2".play()
	$OmniLight3D11.visible=true






	 # Replace with function body.
