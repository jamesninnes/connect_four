import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  GameBoard({Key key, this.columns, this.rows}) : super(key: key);

  final int rows;
  final int columns;

  // Each position is either a 0: representing blank,
  // 1: representing player 1, 
  // or 2: representing player 2
  // TODO Make this dynamic based on columns and rows
  List<List<int>> gameState = [[0, 0, 0, 0, 0, 0, 0,],
                              [0, 0, 0, 0, 0, 0, 0,],
                              [0, 0, 0, 0, 0, 0, 0,],
                              [0, 0, 0, 0, 0, 0, 0,],
                              [0, 0, 0, 0, 0, 0, 0,],
                              [0, 0, 0, 0, 0, 0, 0,]];

  int activePlayer = 1;
  Color activeColor = Colors.red;
  bool gameFinished = false;
  Map winCounter = {
    1: 0,
    2: 0
  };
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          crossAxisCount: widget.columns,
          children: List.generate((widget.columns * widget.rows), (index) {

            // Gets the coordinates of this index in the array
            int xPosition = index % widget.columns;
            int yPosition = (index / widget.columns).floor();

            return InkWell(
              key: Key('InkWell' + index.toString()),
              onTap: () {
                setState(() {
                  // Checks if there is a token underneath and the drops it
                  if (!widget.gameFinished){
                    widget.gameState = dropToken(widget.gameState, widget.rows, xPosition, widget.activePlayer);
                  } else {
                    return;
                  }

                  // Checks if the player has won or drawn
                  if (checkForWinner(widget.gameState, widget.columns, widget.rows, widget.activePlayer)) {
                    // Ends the game and no longer allows moves
                    widget.gameFinished = true;

                    //Counts the win
                    widget.winCounter[widget.activePlayer]++;
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                          title: Text('Player ' + widget.activePlayer.toString() + ' won!', textAlign: TextAlign.center),
                          content: Text('Press the reset button to play again', textAlign: TextAlign.center)
                      )
                    );
                  } else if (checksForDraw(widget.gameState, widget.columns, widget.activePlayer)) {
                    // Ends the game and no longer allows moves
                    widget.gameFinished = true;
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                          title: Text("It's a draw!", textAlign: TextAlign.center),
                          content: Text('Press the reset button to play again', textAlign: TextAlign.center)
                      )
                    );
                  } else {
                    // Changes between players (next turn)
                    widget.activePlayer = changePlayer(widget.activePlayer);
                  }
                });
              },
              child: Container(
                decoration: getBoxDecoration(widget.gameState[yPosition][xPosition]),
              )
            );
          })
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.red
              ),
              label: Text('Player One: ' + widget.winCounter[1].toString()),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.yellow
              ),
              label: Text('Player Two: ' + widget.winCounter[2].toString()),
            ),
          ],
        ),
        FlatButton(
          child: Text('Reset', style: TextStyle(color: Colors.white)),
          onPressed: () {
            setState(() {
              widget.gameState = resetGame(widget.gameState);
              widget.gameFinished = false;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Theme.of(context).primaryColor
        ),
      ],
    );
  }
}

// TODO consolidate this as there is some code duplication
/// This handles the coloration of the slots in the game board
getBoxDecoration(int playerNumber) {
  if (playerNumber == 1) {
    // Red token for player one
    return BoxDecoration(
      border: Border.all(width: 2.0, color: Colors.black),
      shape: BoxShape.circle,
      color: Colors.red
    );
  } else if (playerNumber == 2) {
    // Yellow token for player two
    return BoxDecoration(
      border: Border.all(width: 2.0, color: Colors.black),
      shape: BoxShape.circle,
      color: Colors.yellow
    );
  } else {
    // Blank slot
    return BoxDecoration(
      border: Border.all(width: 2.0, color: Colors.black),
      shape: BoxShape.circle,
      color: Colors.white
    );
  }
}

/// Handles the gravity effect when dropping a token in a column
dropToken(List<List<int>> gameState, int rows, int xPosition, int activePlayer) {
  for (int row = rows - 1; row > -1; row--) {
    // If the lowest position is blank
    if (gameState[row][xPosition] == 0) {

      // Marks the position in the game state with the players number
      gameState[row][xPosition] = activePlayer;
      return gameState;
    }
  }

  // If the row is already full just return the game state
  return gameState;
}

/// If the top row if full, the game is a draw
checksForDraw(List<List<int>> gameState, int columns, int activePlayer) {
  for (int i = 0; i < columns; i++) {
    if (gameState[0][i] == 0) {
      break;
    } else if (i == columns - 1) {
      return true;
    }
  }

  return false;
}

/// Iterates through all of the win conditions
checkForWinner(List<List<int>> gameState, int rows, int columns, int activePlayer) {
    // Checks for a horizontal win 
    for (int j = 0; j < rows - 3 ; j++ ) {
        for (int i = 0; i < columns; i++) {
            if (gameState[i][j] == activePlayer 
            && gameState[i][j + 1] == activePlayer 
            && gameState[i][j + 2] == activePlayer 
            && gameState[i][j + 3] == activePlayer) {
                return true;
            }           
        }
    }

    // Checks for a vertical win 
    for (int i = 0; i < columns - 3 ; i++ ) {
        for (int j = 0; j < rows; j++) {
            if (gameState[i][j] == activePlayer 
            && gameState[i + 1][j] == activePlayer 
            && gameState[i + 2][j] == activePlayer 
            && gameState[i + 3][j] == activePlayer) {
                return true;
            }           
        }
    }

    // Checks for an ascending diagonal win 
    for (int i = 3; i < columns; i++) {
        for (int j = 0; j < rows - 3; j++) {
            if (gameState[i][j] == activePlayer 
            && gameState[i - 1][j + 1] == activePlayer 
            && gameState[i - 2][j + 2] == activePlayer 
            && gameState[i - 3][j + 3] == activePlayer) {
              return true;
            }
        }
    }

    // Checks for a descending diagonal win 
    for (int i = 3; i < columns; i++) {
        for (int j = 3; j < rows; j++) {
            if (gameState[i][j] == activePlayer 
            && gameState[i - 1][j - 1] == activePlayer 
            && gameState[i - 2][j - 2] == activePlayer 
            && gameState[i - 3][j - 3] == activePlayer) {
              return true;
            }
        }
    }
    return false;
}

/// Changes from player one to player two and vice versa
changePlayer(activePlayer) {
  if (activePlayer == 1) {
    return 2;
  } else {
    return 1;
  }
}

// TODO make this a loop so it is dynamic
/// Sets all of the token slots to empty
resetGame(List<List<int>> gameState) {
  return [[0, 0, 0, 0, 0, 0, 0,],
          [0, 0, 0, 0, 0, 0, 0,],
          [0, 0, 0, 0, 0, 0, 0,],
          [0, 0, 0, 0, 0, 0, 0,],
          [0, 0, 0, 0, 0, 0, 0,],
          [0, 0, 0, 0, 0, 0, 0,]];
}