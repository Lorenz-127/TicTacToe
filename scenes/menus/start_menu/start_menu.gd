extends CanvasLayer

signal start_game
signal exit_game

func _on_start_button_pressed():
	start_game.emit()
	

func _on_exit_button_pressed():
	exit_game.emit()
