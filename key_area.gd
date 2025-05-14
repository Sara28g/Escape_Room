extends Area3D

signal key_taken

func _on_mouse_entered() -> void:
	print("Key area")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Key taken")
		emit_signal("key_taken")
		queue_free()
