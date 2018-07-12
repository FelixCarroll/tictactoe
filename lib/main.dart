import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TicTacToe(size: 6,),
    );
  }
}


//---------------- APP -------------------



class Player {
  // Hold information regarding players
  MaterialColor color;
  String symbol;
  String name;
  Player({@required this.name, @required this.symbol, this.color});
}

enum TicTacToeState {
  // Identifies the different states the game can be in.
  gameOver, player1, player2, winner1, winner2
}

enum TicTacToeSymbol {
  // Used to store information about player moves, remove the abuguity when
  // users customize there symbol
  empty, player1, player2
}

class TicTacToeEngine {
  TicTacToeState state;
  List<TicTacToeSymbol> grid;
  int size;

  TicTacToeEngine({this.state : TicTacToeState.player1, this.size : 3}){
      grid = List<TicTacToeSymbol>.generate(size * size, (int index) {
        return TicTacToeSymbol.empty;
    });
  }

  void changeTurn() {
    if(state == TicTacToeState.player1) {
      state = TicTacToeState.player2;
    } else if(state == TicTacToeState.player2){
      state = TicTacToeState.player1;
    }
  }

  bool moveAble() {
    return state == TicTacToeState.player1 || state == TicTacToeState.player2;
  }

  bool checkEmpty(int index) {
    return grid[index] == TicTacToeSymbol.empty;
  }

  void insertSymbol(int index){
    if(state == TicTacToeState.player1) {
      grid[index] = TicTacToeSymbol.player1;
    } else {
      grid[index] = TicTacToeSymbol.player2;
    }
  }

  void move(int index) {
    if(moveAble()) {
      if(checkEmpty(index)){
        insertSymbol(index);
      } else {
        print("Square $index is already used");
      }
    } else {
      print("No moves are currently available");
    }
  }

  void action(int e) {
    move(e);
    //TODO : Check whether the game is won or is a draw
    changeTurn();
  }

}

class TicTacToe extends StatefulWidget {
  // Tic Tac Toe Widget that contains the App
  // Currently has a grid and a reset button

  Player player1 = new Player(name: "Player 1", symbol: "X", color: Colors.blue);
  Player player2 = new Player(name: "Player 2", symbol: "O", color: Colors.red);
  TicTacToeEngine game;


  int size;
  TicTacToe({this.size : 3}){
    game = new TicTacToeEngine(size: size);
  }

  @override
  _TicTacToeState createState() => _TicTacToeState();

}

class _TicTacToeState extends State<TicTacToe> {

  String engineToValue (TicTacToeSymbol player){
    // Converts TicTacToeSymbol in the players customized symbol
    if(player == TicTacToeSymbol.player1) {
      return widget.player1.symbol;
    } else if(player == TicTacToeSymbol.player2) {
      return widget.player2.symbol;
    } else {
      return "";
    }
  }
  
  MaterialColor colorCustomization(TicTacToeSymbol player) {
    // Converts grid color to the players color customization
    if(player == TicTacToeSymbol.player1) {
      return widget.player1.color;
    } else if(player == TicTacToeSymbol.player2) {
      return widget.player2.color;
    } else {
      return Colors.grey;
    }
  }

  MaterialColor convertStateToColor(TicTacToeState player){
    if(player == TicTacToeState.player1) {
      return widget.player1.color;
    } else if(player == TicTacToeState.player2) {
      return widget.player2.color;
    } else {
      return Colors.grey;
    }
  }

  void _handleGridButtonTap (int index) {
    // Handles event that occur when a button is pushed
    setState(() {
      widget.game.action(index);
    });
  }

  void _handleReset() {
    // Resets the game engine to a new instance and calls setState to
    // redraw the grid
    setState(() {
      widget.game = new TicTacToeEngine(size:widget.size);
    });
  }

  @override
  Widget build(BuildContext context) {

    // 3 x 3 Grid Physical representation
    Widget grid =  GridView.count(
      crossAxisCount: widget.size,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: new List<Widget>.generate(widget.size * widget.size, (int index) {
        return new TicTacToeBox(
          id: index,
          onTap: _handleGridButtonTap,
          value: engineToValue(widget.game.grid[index]),
          color: colorCustomization(widget.game.grid[index]),
        );
      }),
    );

    // Reset Button
    Widget reset = new IconButton(
        icon: new Icon(Icons.refresh),
        onPressed: _handleReset,
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text("TicTacToe"),
        backgroundColor: convertStateToColor(widget.game.state),
        actions: <Widget>[
          reset,
        ],
      ),
      body: grid,
    );
  }
}


class TicTacToeBox extends StatelessWidget {
  // TicTacToe Box used to display the values and the color within the game engine
  TicTacToeBox({Key key, @required this.id, @required this.onTap, this.value : "", this.color : Colors.grey, }) : super(key: key);

  final int id;
  final String value;
  final MaterialColor color;
  final ValueChanged<int> onTap;

  void _handleTap () {
    // Callback to the State manager TicTacToe._handleGridButton()
    onTap(id);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: color,
        onPressed: _handleTap,
        child: new Text(value)
    );
  }




}