extends Node3D

var is_open = false

func interact():
	if not is_open:
		$AnimationPlayer.play("OpenChest")
		is_open = true
