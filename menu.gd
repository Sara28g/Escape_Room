extends Button

var once=true

func _on_pressed() -> void:
	if once:
		$"../Panel".visible=true
		once=false
		$"../../Control/Panel".visible=false
	else:
		$"../Panel".visible=false
		once=true
	
	
	
