extends Control

signal rostop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func stop():
	if $q_1.visible or $qs2.visible or $qs3.visible:
		emit_signal("rostop")
		print("drag stop")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
