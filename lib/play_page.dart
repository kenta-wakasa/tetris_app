import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/play_model.dart';
import 'package:tetris_app/start_page.dart';
import 'render_mino.dart';

class PlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayModel>(
      create: (_) => PlayModel()..countDown(),
      child: Consumer<PlayModel>(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'TETRIS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CustomPaint(
                        painter: RenderMino(
                          currentMino: model.currentMino,
                          fixedMino: model.fixedMino,
                        ),
                      ),
                    ),
                  ),
                  SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              minWidth: 12,
                              onPressed: () {
                                model.rotateLeft();
                              },
                              child: Icon(Icons.sync),
                              shape: CircleBorder(),
                              color: Colors.white,
                            ),
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: MaterialButton(
                                minWidth: 12,
                                onPressed: () {
                                  model.rotateRight();
                                },
                                shape: CircleBorder(),
                                child: Icon(Icons.sync),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: MaterialButton(
                                minWidth: 12,
                                onPressed: () {
                                  model.moveLeft();
                                },
                                child: Icon(
                                  Icons.arrow_left,
                                  color: Colors.white,
                                ),
                                shape: CircleBorder(),
                                color: Colors.redAccent,
                              ),
                            ),
                            MaterialButton(
                              minWidth: 12,
                              onPressed: () {
                                model.moveRight();
                              },
                              child: Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                              ),
                              shape: CircleBorder(),
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  model.gameOver
                      ? Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.brown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Game Over',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 36),
                                ),
                                SizedBox(
                                  height: 240,
                                ),
                                SizedBox(
                                  width: 240,
                                  child: RaisedButton(
                                    color: Colors.redAccent,
                                    child: Text(
                                      'もう一度あそぶ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      model.reset();
                                      model.countDown();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  width: 240,
                                  child: RaisedButton(
                                    color: Colors.redAccent,
                                    child: Text(
                                      'タイトル画面にもどる',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      model.reset();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StartPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 56,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  model.count > -1
                      ? Center(
                          child: Text(
                            model.count != 0 ? model.count.toString() : 'GO!!',
                            style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[900],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
