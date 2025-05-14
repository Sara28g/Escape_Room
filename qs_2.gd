extends Control

@onready var line: Line2D = $Line2D
var stop=false
var drawing := false
var start_point: Vector2  # Will be set to the middle of the rect in _ready()
var grid_size: float = 0.5  # Grid square side length
var grid_origin: Vector2 = Vector2(0, 0)  # Reference point for grid snapping
# Manually specified size and position of the TextureRect
var rect_min: Vector2 = Vector2(584.0, 64)  # Position of the TextureRect
var rect_size: Vector2 = Vector2(450, 450)  # Size of the TextureRect
var rect_max: Vector2 = rect_min + rect_size  # Max bounds of the TextureRect

func _ready():
	# Calculate the center of the TextureRect
	start_point = rect_min + rect_size / 2
	line.width = 2  # Set line width to thin
	line.clear_points()
	line.add_point(start_point)  # Start from the center of the TextureRect

func _process(delta):
	if drawing:
		# Snap the end point of the line to the grid and clamp it within the TextureRect
		var end_point = snap_to_grid(get_global_mouse_position())
		
		# Only update the line if inside the TextureRect bounds
		if is_inside_rect(end_point):
			end_point = clamp_to_rect(end_point)
			# Clear the previous points and update the line to only have the start and end points
			line.clear_points()
			line.add_point(start_point)
			line.add_point(end_point)  # Always draw from start_point to the snapped end point
			draw_arrowhead(start_point, end_point)

func _input(event):
	if stop==false and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		
		if event.pressed and stop==false:
			if is_inside_rect(mouse_pos):
				# Start drawing: set the first point to the center of the TextureRect
				drawing = true
				line.clear_points()  # Clear any previous points
				line.add_point(start_point)
		else:
			# On mouse release, finalize the end point and draw the arrow if inside the TextureRect
			var end_point = snap_to_grid(mouse_pos)
			if end_point != start_point and is_inside_rect(end_point) and stop==false:  # Prevents drawing zero-length arrows
				end_point = clamp_to_rect(end_point)
				line.clear_points()
				line.add_point(start_point)
				line.add_point(end_point)
				var arrow_tip = draw_arrowhead(start_point, end_point)
				print_arrow_tip_position(arrow_tip)
			drawing = false

func is_inside_rect(position: Vector2) -> bool:
	# Check if the position is within the bounds of the TextureRect
	return position.x >= rect_min.x and position.x <= rect_max.x and position.y >= rect_min.y and position.y <= rect_max.y

func snap_to_grid(position: Vector2) -> Vector2:
	# Snap to grid lines instead of centers
	var snapped_x = round((position.x - grid_origin.x) / grid_size) * grid_size + grid_origin.x
	var snapped_y = round((position.y - grid_origin.y) / grid_size) * grid_size + grid_origin.y
	return Vector2(snapped_x, snapped_y)

func clamp_to_rect(position: Vector2) -> Vector2:
	# Clamp the position to ensure it stays within the TextureRect bounds
	var clamped_x = clamp(position.x, rect_min.x, rect_max.x)
	var clamped_y = clamp(position.y, rect_min.y, rect_max.y)
	return Vector2(clamped_x, clamped_y)

func draw_arrowhead(start: Vector2, end: Vector2) -> Vector2:
	# Remove previous arrowheads
	for child in get_children():
		if child is Line2D and child != line and stop==false:
			child.queue_free()
	var direction = (end - start).normalized()
	var arrow_size = 15  # Fixed arrowhead size
	var arrow_thickness = 2  # Arrowhead thickness
	# Always use fixed angle for the arrowhead wings
	var left_wing = snap_to_grid(end - (direction.rotated(PI / 6) * arrow_size))
	var right_wing = snap_to_grid(end - (direction.rotated(-PI / 6) * arrow_size))
	# Clamp the arrowhead wings to the TextureRect bounds
	left_wing = clamp_to_rect(left_wing)
	right_wing = clamp_to_rect(right_wing)
	# Create the arrowhead
	var arrow = Line2D.new()
	arrow.default_color = Color.WHITE
	arrow.width = arrow_thickness
	arrow.add_point(end)
	arrow.add_point(left_wing)
	arrow.add_point(end)
	arrow.add_point(right_wing)
	add_child(arrow)
	return end  # Return the arrow tip position

func print_arrow_tip_position(tip_position: Vector2):
	# Print the position of the arrow tip
	print("Arrow tip position: ", tip_position)
	# You can also format the output if needed
	print("X: %.2f, Y: %.2f" % [tip_position.x, tip_position.y])


func _on_submit_stop_1() -> void:
	stop=true # Replace with function body.
