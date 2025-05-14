extends Control
signal sceneover
signal closejoystick
signal clock_opened
var in_clock_zone=false
signal reset
func _ready() -> void:
	if $".".visible == true:
		emit_signal("closejoystick")
		print("true") 
	
func _on_answer_button_pressed():
	self.visible = false 
	
func ifopen():
	if $".".visible == true:
		emit_signal("closejoystick")
		print("true") # Hide the panel when answered


func _on_pressed() -> void:
	pass # Replace with function body.


func _on_close_pressed() -> void:
	emit_signal("sceneover")
	$".".visible=false
	pass # Replace with function body.

func resstart_game():
	emit_signal("reset")

func _on_submit_connect_to() -> void:
	emit_signal("clock_opened")
 # Replace with function body.
