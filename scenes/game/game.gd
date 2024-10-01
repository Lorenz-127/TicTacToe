extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

# sets the play mode
var pve_mode : String = "PvE"
var pvp_mode : String = "PvP"
var current_mode : String = pvp_mode

# sets the variables for the functions
var player : int
var moves : int
var winner : int
var temp_marker
var player_panel_pos : Vector2i
var board_size : int
var cell_size : int = 100
var grid_data : Array = []
var grid_pos : Vector2i
var row_sum : int
var col_sum : int
var diagonal1_sum : int
var diagonal2_sum : int


# Called when the node enters the scene tree for the first time.
func _ready():
	show_start_menu()

# display the start menu and pause the game
func show_start_menu():
	$StartMenu.show()
	get_tree().paused = false


# starts the game
func game_start():
	$StartMenu.hide()
	board_size = $Board.texture.get_width()
	# divide board size by 3 to get the size of individual cell

	# Handle the cell_size warning error calculation more gracefully
	if board_size != 0:
		# divide board size by 3 to get the size of individual cell
		cell_size = board_size / 3
	else:
		cell_size = 100  # fallback if texture size fails

	# get the position of the next player panel
	player_panel_pos = $PlayerPanel.position
	new_game()

# handles the input from the player
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# check if the click is inside the board
			if event.position.x < board_size:
				# convert the click position to grid position
				grid_pos = Vector2i(event.position / cell_size)
				# check if the cell is empty
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					# allow move if it's PvP or if it's human's turn in PvE
					if current_mode == pvp_mode or (current_mode == pve_mode and player == 1):
						# call make moves function
						make_move(grid_pos)
						
						# check for game continuation
						if check_win() == 0 and moves < 9:
							# switch to the next player
							switch_player()
							# if in PvE mode and it's AI's turn, make AI move
							if current_mode == pve_mode and player == -1:
								ai_move()

# makes a move on the board
func make_move(pos):
	# increment move counter
	moves += 1
	# set the cell to the current player
	grid_data[pos.y][pos.x] = player
	# create current player's marker
	create_marker(player, pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
	
	# check if the current player has won
	if check_win() != 0:
		# call end game function
		end_game()
	# check for a draw
	elif moves == 9:
		# call end game function with draw condition
		end_game(true)

# handles AI move in PvE mode
func ai_move():
	# wait for 1.5 seconds before making a move
	await get_tree().create_timer(1.5).timeout
	# get a list of all empty cells on the board
	var empty_cells = get_empty_cells()
	# check if there are any empty cells left
	if empty_cells.size() > 0:
		# choose a random empty cell for the AI's move
		var random_cell = empty_cells[randi() % empty_cells.size()]
		# make the move on the chosen cell
		make_move(random_cell)
		# check for game continuation and switch back to human player
		if check_win() == 0 and moves < 9:
			switch_player()

# switches to the next player
func switch_player():
	# change to the other player
	player *= -1
	# remove the old temporary marker
	if temp_marker:
		temp_marker.queue_free()
	# update to the next player marker
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
	# update the player label
	update_player_label()

func update_player_label():
	# sets condition for label to show next player
	var player_text = "Player 1" if player == 1 else ("AI" if current_mode == pve_mode else "Player 2")
	# displays player whose turn it is
	$PlayerLabel.text = player_text

func get_empty_cells():
	# calculate moves for AI player
	var empty = []
	for y in range(3):
		for x in range(3):
			if grid_data[y][x] == 0:
				empty.append(Vector2i(x, y))
	return empty


# restarts the game
func new_game():
	# display game mode
	$ModeLabel.text = "Mode: " + current_mode
	# initialize the player
	player = 1
	# initialize the moves
	moves = 0
	# # initialize the winner
	winner = 0
	# initialize the grid data
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
		]
	# clear all the sum variables
	row_sum = 0
	col_sum = 0
	diagonal1_sum = 0
	diagonal2_sum = 0
	#clear existing markers
	get_tree().call_group("circles", "queue_free")
	get_tree().call_group("crosses", "queue_free")
	# create a temporary marker for the next player
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size /2 ), true)
	# Game Over Panel is hidden
	$GameOver.hide()
	get_tree().paused = false


# creates the correct marker for player
func create_marker(player, position, temp=false):
	var marker
	# set circle for player 1
	if player == 1:
		marker = circle_scene.instantiate()
	# set cross for player 2
	else:
		marker = cross_scene.instantiate()
	marker.position = position
	add_child(marker)
	if temp:
		temp_marker = marker

# check win condition
func check_win():
	# add the row, column, and diagonal sums
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]

		# check if any of the sums are 3 or -3
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = -1
	return winner

# check for winning player and set game over winn text
func end_game(is_tie = false):
	# pasue the game
	get_tree().paused = true
	# show game over panel
	$GameOver.show()
	# display correct win text
	if is_tie:
		$GameOver/GameOverPanel/VBoxContainer/WinnerLabel.text = "It's a Tie!"
	else:
		var winner_text = "Player 1" if winner == 1 else ("AI" if current_mode == pve_mode else "Player 2")
		$GameOver/GameOverPanel/VBoxContainer/WinnerLabel.text = winner_text + " Wins!"

# restarts the game from game over menu
func _on_game_over_restart_game():
	new_game()

# starts the game
func _on_start_menu_start_game():
	game_start()

# show the start menu
func _on_game_over_main_menu():
	$GameOver.hide()
	#clear existing markers
	get_tree().call_group("circles", "queue_free")
	get_tree().call_group("crosses", "queue_free")
	show_start_menu()

# exits the game
func _on_start_menu_exit_game():
	get_tree().quit()

# opens the options menu
func _on_start_menu_open_options():
	$OptionsMenu.show()

# brings the player back to main menu
func _on_options_menu_back_to_main():
	$OptionsMenu.hide()
	$StartMenu.show()
 
# set pve mode = player 1 vs. AI
func _on_options_menu_pve_mode():
	current_mode = pve_mode
	$ModeLabel.text = "Mode: " + current_mode

# set game mode
func _on_start_menu_game_mode():
	current_mode = pve_mode if current_mode == pvp_mode else pvp_mode
	$ModeLabel.text = "Mode: " + current_mode
