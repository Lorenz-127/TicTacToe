extends CanvasLayer

signal restart_game
signal main_menu


# send signal to main to connect back button
func _on_back_button_pressed():
	main_menu.emit()

# send signal to main to connect restart button
func _on_restart_button_pressed():
	restart_game.emit()
