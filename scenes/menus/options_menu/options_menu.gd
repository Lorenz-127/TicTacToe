extends CanvasLayer


signal back_to_main


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_back_button_pressed():
	back_to_main.emit()
