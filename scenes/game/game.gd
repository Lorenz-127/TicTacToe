extends Node

@export var circle_scene : PackedScene
@export var cross_scene : PackedScene


var player : int
var moves : int
var winner : int
var temp_marker
var player_panel_pos : Vector2i
var board_size : int
var cell_size : int
var grid_data : Array = []
var grid_pos : Vector2i
var row_sum : int
var col_sum : int
var diagonal1_sum : int
var diagonal2_sum : int


# Called when the node enters the scene tree for the first time.
func _ready():
	show_start_menu()
	
func show_start_menu():
	$StartMenu.show()
	get_tree().paused = false
	

func game_start():
	$StartMenu.hide()
	board_size = $Board.texture.get_width()
	# divide board size by 3 to get the size of individual cell

	# Handle the cell_size warning error calculation more gracefully
	if board_size != 0:
		# divide board size by 3 to get the size of individual cell
		cell_size = board_size / 3
	else:
		cell_size = 0  # or any default integer value you prefer

	# get the position of the next player panel
	player_panel_pos = $PlayerPanel.position
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			#check if the click is inside the board
			if event.position.x < board_size:

				# convert the click position to grid position
				grid_pos = Vector2i(event.position / cell_size)
				# check if the cell is empty
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					# counts moves
					moves += 1
					# set the cell to the current player
					grid_data[grid_pos.y][grid_pos.x] = player
					# create current player's marker
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					# check if the current player has won
					if check_win() != 0:
						# pause the game
						get_tree().paused = true
						# show the game over panel
						$GameOver.show()
						# display winner in winner label
						if winner == 1:
							$GameOver/GameOverPanel/VBoxContainer/WinnerLabel.text = "Player 1 Wins!"
						elif winner == -1:
							$GameOver/GameOverPanel/VBoxContainer/WinnerLabel.text = "Player 2 Wins!"
						
					# check for a draw
					elif moves == 9:
						# pause the game
						get_tree().paused = true
						# show the game over panel
						$GameOver.show()
						$GameOver/GameOverPanel/VBoxContainer/WinnerLabel.text = "It's a Tie!"

					player *= -1
					# remove the old temporary marker
					temp_marker.queue_free()
					# update to the next player marker
					create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
					print(grid_data)


func new_game():
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



func create_marker(player, position, temp=false):
	# create a marker and add it to the board as a child
	if player == 1:
		# instantiate the circle scene player 1
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		# set the next player to the circle
		if temp: temp_marker = circle
	else:
		# instantiate the cross scene player 2
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		# set the next player to the cross
		if temp: temp_marker = cross

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

# restarts the game from game over menu
func _on_game_over_restart_game():
	new_game()
	

func _on_start_menu_start_game():
	game_start()


func _on_game_over_main_menu():
	$GameOver.hide()
	#clear existing markers
	get_tree().call_group("circles", "queue_free")
	get_tree().call_group("crosses", "queue_free")
	show_start_menu()


func _on_start_menu_exit_game():
	get_tree().quit()
