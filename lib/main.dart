import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tic Tac Toe'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  var tiles = List.filled(9, 0);
  var tileColor = Colors.grey[200];

  islost() {
    setState(() {
      tileColor = Colors.red;
    });
  }

  restrtTileColour() {
    setState(() {
      tileColor = Colors.grey[200];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GridView.count(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 3,
              children: [
                for (var i = 0; i < 9; i++)
                  Container(
                    color: tileColor,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          tiles[i] = 1;
                          runAi();
                        });
                      },
                      child: Center(
                          child: Text(tiles[i] == 0
                              ? ''
                              : tiles[i] == 1
                                  ? 'X'
                                  : 'O')),
                    ),
                  )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(isWinning(1, tiles)
                  ? 'You won!'
                  : isWinning(2, tiles)
                      ? 'You lost!'
                      : 'Your move'),
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      tiles = List.filled(9, 0);
                    });
                    restrtTileColour();
                  },
                  child: Text('Restart'))
            ],
          )
        ],
      ),
    );
  }

  void runAi() async {
    await Future.delayed(Duration(milliseconds: 200));

    int? winning;
    int? blocking;
    int? normal;

    for (var i = 0; i < 9; i++) {
      var val = tiles[i];

      if (val > 0) {
        continue;
      }

      var future = [...tiles]..[i] = 2;

      if (isWinning(2, future)) {
        winning = i;
        islost();
      }

      future[i] = 1;

      if (isWinning(1, future)) {
        blocking = i;
      }

      normal = i;
    }

    var move = winning ?? blocking ?? normal;

    if (move != null) {
      setState(() {
        tiles[move] = 2;
      });
    }
  }

  bool isWinning(int who, List<int> tiles) {
    return (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[3] == who && tiles[4] == who && tiles[5] == who) ||
        (tiles[6] == who && tiles[7] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[4] == who && tiles[8] == who) ||
        (tiles[2] == who && tiles[4] == who && tiles[6] == who) ||
        (tiles[0] == who && tiles[3] == who && tiles[6] == who) ||
        (tiles[1] == who && tiles[4] == who && tiles[7] == who) ||
        (tiles[2] == who && tiles[5] == who && tiles[8] == who);
  }
}
