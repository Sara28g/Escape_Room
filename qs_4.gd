extends Control

signal sceneover
signal callelect
signal reset
func _on_submit_q_4_correct() -> void:
	emit_signal("callelect") # Replace with function body.

func resstart_game():
	emit_signal("reset")
func _on_close_sceneover() -> void:
	emit_signal("sceneover") # Replace with function body.
