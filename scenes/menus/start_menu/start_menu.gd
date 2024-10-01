extends CanvasLayer

signal start_game
signal exit_game
signal open_options
signal game_mode

func _on_start_button_pressed():
	start_game.emit()
	

func _on_exit_button_pressed():
	exit_game.emit()
	

func _on_options_button_pressed():
	open_options.emit()


func _on_game_mode_button_pressed():
	game_mode.emit()
