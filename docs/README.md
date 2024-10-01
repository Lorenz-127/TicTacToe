# Classic Tic Tac Toe Game

This is a simple Tic Tac Toe game implemented using the Godot game engine. The game features a graphical user interface with a start menu, game board, and game over screen. Build with Godot 4.3 and GDScript.
<br>
<img alt="gdscript" src="https://img.shields.io/badge/-GODOT-478CBF?style=flat-square&logo=godotengine&logoColor=white" />

## Features

- Start menu with options to start the game, access options (not implemented), or exit
- 3x3 game board
- Two-player gameplay (X and O)
- Game over screen showing the winner or a tie
- Option to restart the game or return to the main menu after a game ends

## How to Play

1. Launch the game
2. Click "Start Game" on the start menu
3. Players take turns clicking on empty cells to place their marker (X or O)
4. The game ends when a player gets three in a row (horizontally, vertically, or diagonally) or when all cells are filled (resulting in a tie)
5. After the game ends, choose to play again or return to the main menu

## Technical Details

- The game uses a 3x3 grid to represent the game state
- Player moves are tracked using 1 (for player 1) and -1 (for player 2) in the grid
- Win conditions are checked by summing rows, columns, and diagonals
- The UI is created using Godot's built-in nodes and scenes

## Future Improvements

- [ ]  Implement the options menu functionality
- [ ]  Add sound effects and background music
- [ ]  Create an AI opponent for single-player mode
- [ ]  Enhance the visual design with animations and particle effects
- [ ] Export to Desktop, Web, and Mobile

## Requirements

This game is built with Godot Engine. To run or modify the game, you'll need:

- Godot Engine 4.3 [Download](https://godotengine.org/)

## License

MIT Licence

## Credits

The ispiration comes from this [YouTube Tutorial](https://youtu.be/w6leMEr1aGo) by [Coding With Russ](https://www.youtube.com/@CodingWithRuss)
