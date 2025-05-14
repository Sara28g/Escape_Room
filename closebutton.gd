extends Button

signal sceneover

func _on_pressed():
	emit_signal("sceneover")
	$"..".visible=false
	
