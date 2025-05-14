extends Control

@onready var subviewport = $SubViewportContainer/SubViewport
@onready var preview_node = $SubViewportContainer/SubViewport/cube
@onready var close_button = $Button

var item_instance: Node3D

func _ready():
	close_button.pressed.connect(_on_close_pressed)
	set_process_input(true)  # Ensure input events are processed

func show_preview(item: Node3D):
	if item_instance:
		item_instance.queue_free()  # Remove any previous preview object

	# Duplicate the selected item
	item_instance = item.duplicate()
	
	if not item_instance:
		print("ERROR: item_instance is NULL!")
		return

	# Reset transform so it appears correctly
	item_instance.global_transform = Transform3D()

	# Add the duplicated item to the preview node
	preview_node.add_child(item_instance)

	# Show the preview UI
	visible = true

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if item_instance:
			item_instance.rotate_object_local(Vector3.UP, -event.relative.x * 0.01)
			item_instance.rotate_object_local(Vector3.RIGHT, -event.relative.y * 0.01)

func _on_close_pressed():
	if item_instance:
		item_instance.queue_free()  # Remove the item when closing
	visible = false
