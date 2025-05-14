# Global.gd
extends Node

var user_id: String = "guest"

func set_user_id(id: String) -> void:
	user_id = id
	print("User ID set to: ", user_id)
