extends Control

signal sceneover
signal  correct5
signal reset
func _on_submit_q_5_correct() -> void:
	emit_signal("correct5")
func resstart_game():
	emit_signal("reset")

func _on_close_sceneover() -> void:
	emit_signal("sceneover") # Replace with function body.
