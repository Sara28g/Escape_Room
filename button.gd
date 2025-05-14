extends Button

signal custom_button_pressed

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	emit_signal("custom_button_pressed")
