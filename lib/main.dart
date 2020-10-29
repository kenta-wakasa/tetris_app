import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/main_model.dart';
import 'mino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel(),
      child: Consumer<MainModel>(builder: (context, model, child) {
        return MaterialApp(
          title: 'TETRIS',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      backgroundColor: Colors.amberAccent,
                      onPressed: () {
                        model.rotateRight();
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                        model.rotateLeft();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
            appBar: AppBar(
              title: Text('TETRIS'),
            ),
            body: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: 240,
                      height: 480,
                      color: Colors.grey,
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: Jmino(
                              xPos: model.xPos,
                              yPos: model.yPos,
                              angle: model.angle,
                              fixedMino: model.fixedMino,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        child: const Text('←'),
                        color: Colors.white,
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        onPressed: () {
                          model.moveLeft();
                        },
                      ),
                      RaisedButton(
                        child: Text('Start'),
                        onPressed: () {
                          model.startTimer();
                        },
                      ),
                      RaisedButton(
                        child: Text('Reset'),
                        onPressed: () {
                          model.reset();
                        },
                      ),
                      RaisedButton(
                        child: const Text('→'),
                        color: Colors.white,
                        shape: const CircleBorder(
                          side: BorderSide(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        onPressed: () {
                          model.moveRight();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
