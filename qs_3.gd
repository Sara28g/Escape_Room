extends Control

signal opendrawer
signal reset
func _on_submit_opendrawer() -> void:
	emit_signal("opendrawer") # Replace with function body.
func resstart_game():
	emit_signal("reset")
