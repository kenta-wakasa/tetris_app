import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/main_model.dart';
import 'render_mino.dart';

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
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          width: 40,
                          height: 40,
                          child: FloatingActionButton(
                            child: Icon(Icons.sync),
                            backgroundColor: Colors.amberAccent,
                            onPressed: () {
                              model.rotateLeft();
                            },
                          ),
                        ),
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            width: 40,
                            height: 40,
                            child: FloatingActionButton(
                              child: Icon(Icons.sync),
                              backgroundColor: Colors.amberAccent,
                              onPressed: () {
                                model.rotateRight();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          width: 40,
                          height: 40,
                          child: FloatingActionButton(
                            child: Icon(Icons.arrow_left),
                            backgroundColor: Colors.redAccent,
                            onPressed: () {
                              model.moveLeft();
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2.0),
                          width: 40,
                          height: 40,
                          child: FloatingActionButton(
                            child: Icon(Icons.arrow_right),
                            backgroundColor: Colors.redAccent,
                            onPressed: () {
                              model.moveRight();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    height: 56,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: 200,
                      height: 400,
                      color: Colors.grey,
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: RenderMino(
                              currentMino: model.currentMino,
                              fixedMino: model.fixedMino,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          RaisedButton(
                            child: Text('Start'),
                            onPressed: () {
                              model.startTimer();
                            },
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          RaisedButton(
                            child: Text('Reset'),
                            onPressed: () {
                              model.reset();
                            },
                          ),
                        ],
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
