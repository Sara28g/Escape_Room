extends Control
signal got
signal sceneover
signal closejoystick
signal reset
func _on_submit_traingo() -> void:
	emit_signal("got")
	emit_signal("closejoystick")
	
func resstart_game():
	emit_signal("reset")

func _on_close_sceneover() -> void:
	emit_signal("sceneover") # Replace with function body.


func _on_submit_sceneover() -> void:
	pass # Replace with function body.
