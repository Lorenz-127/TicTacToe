extends CanvasLayer

signal start_game


func _on_start_button_pressed():
	start_game.emit()


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
