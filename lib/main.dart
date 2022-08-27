import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/ui/color.dart';
import 'package:tic_tac_toe_game/utils/game_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //rows[1,2,3], cols[1,2,3],diagonal[1,2,3,]

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
    print(result);
    resultModal();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: MainColor.primaryColor,
      backgroundColor: Color(0xff192A32),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 120,
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Color(0xff1F353F),
              boxShadow: [
                BoxShadow(
                    blurRadius: 0,
                    color: Color(0xff102129),
                    offset: Offset(0, 5))
              ],
            ),
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30,
                    child: lastValue == "X"
                        ? SvgPicture.asset(
                            "assets/images/x_game.svg",
                            color: Color(0xff31C4BE),
                          )
                        : SvgPicture.asset(
                            "assets/images/o_game.svg",
                            color: Color(0xffF2B237),
                          ),
                  ),
                  Text(
                    "Turn".toUpperCase(),
                    style: TextStyle(
                        color: Color(0xffA8BEC9),
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              crossAxisCount: Game.boardLength ~/ 3, //method
              padding: EdgeInsets.all(16.0),
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              children: List.generate(Game.boardLength, (index) {
                return InkWell(
                  onTap: gameOver
                      ? () => resultModal()
                      : () {
                          if (game.board![index] == "") {
                            setState(() {
                              game.board![index] = lastValue;
                              turn++;
                              gameOver = game.winnerCheck(
                                  lastValue, index, scoreboard, 3);

                              if (gameOver) {
                                result = "${lastValue} is the Winner";
                              } else if (!gameOver && turn == 9) {
                                result = "It's a Drawl!";
                                gameOver = true;
                              }
                              if (lastValue == "X")
                                lastValue = "O";
                              else
                                lastValue = "X";
                            });
                          }
                        },
                  child: Container(
                    width: Game.blocSize,
                    height: Game.blocSize,
                    decoration: BoxDecoration(
                        // color: MainColor.secondaryColor,
                        color: Color(0xff1F353F),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0,
                              color: Color(0xff102129),
                              offset: Offset(0, 10))
                        ]),
                    child: Center(
                        // child: Text(
                        //   game.board![index],
                        //   style: TextStyle(
                        //     color: game.board![index] == "X"
                        //         ? Colors.blue
                        //         : Colors.pink,
                        //     fontSize: 64.0,
                        //   ),
                        // ),
                        child: status(index)),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            result,
            style: TextStyle(color: Colors.white, fontSize: 54.0),
          ),
          ElevatedButton.icon(
            onPressed: () {
              resultModal();

              setState(() {
                game.board = Game.initGameBoard();
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0,
                ];
              });
            },
            icon: Icon(Icons.replay),
            label: Text("Repeat the Game"),
          ),
        ],
      ),
    );
  }

  status(index) {
    if (game.board![index] == "X") {
      return SizedBox(
        width: 70,
        child: SvgPicture.asset(
          "assets/images/x_game.svg",
          color: Color(0xff31C4BE),
        ),
      );
    } else if (game.board![index] == "O") {
      return SizedBox(
        width: 70,
        child: SvgPicture.asset(
          "assets/images/o_game.svg",
          color: Color(0xffF2B237),
        ),
      );
    }
  }

  // @override
  void resultModal() {
    result == ""
        ? null
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Color(0xff1F353F),
                  ),
                  child: Column(
                    children: [
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: SvgPicture.asset(
                      //     "assets/images/x_game.svg",
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            });
  }
}
