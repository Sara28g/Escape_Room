extends Button
# In your main scene or UI scene in Godot

func _on_close_button_pressed():
	# This will close the Godot app and return to Flutter
	get_tree().quit()
