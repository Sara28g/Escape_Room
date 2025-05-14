extends Node  # or whatever base class you're using

func _ready():
	add_to_group("inventory")

func add_item(texture):
	print("Item added to inventory: ", texture)
	# Your inventory logic here
