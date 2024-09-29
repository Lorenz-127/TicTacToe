extends CanvasLayer

signal restart_game
signal main_menu


func _on_restart_button_pressed():
	restart_game.emit() # send signal to main.gd


func _on_back_button_pressed():
	main_menu.emit()
