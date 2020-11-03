import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/play_model.dart';
import 'package:tetris_app/start_page.dart';
import 'render_mino.dart';

class PlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _centerPos = _size.width / 2;
    double _deltaLeft = 0;
    double _deltaRight = 0;
    double _deltaDown = 0;
    bool _hardDrop = false;
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
                  // タップなどの検知
                  GestureDetector(
                    // 回転処理
                    onTapUp: (details) {
                      if (details.globalPosition.dx < _centerPos) {
                        model.rotateLeft();
                      } else {
                        model.rotateRight();
                      }
                    },
                    // タップ時に初期化
                    onPanDown: (_) {
                      _hardDrop = false;
                      _deltaRight = 0;
                      _deltaLeft = 0;
                      _deltaDown = 0;
                    },
                    onPanUpdate: (details) {
                      // 移動処理
                      if (0 < details.delta.dx) {
                        _deltaRight += details.delta.dx;
                        if (20 < _deltaRight) {
                          model.moveRight();
                          _deltaRight = 0;
                        }
                      } else {
                        _deltaLeft += details.delta.dx.abs();
                        if (20 < _deltaLeft) {
                          model.moveLeft();
                          _deltaLeft = 0;
                        }
                      }
                      if (0 < details.delta.dy) {
                        _deltaDown += details.delta.dy;
                        if (20 < _deltaDown && !_hardDrop) {
                          model.moveDown();
                          _deltaDown = 0;
                        }
                      }
                      // hard drop 処理
                      if (20 < details.delta.dy && !_hardDrop) {
                        _hardDrop = true;
                        _deltaDown = 0;
                        model.hardDrop();
                      }
                    },
                    child: Container(
                      color: Colors.white.withOpacity(0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: CustomPaint(
                        painter: RenderMino(
                          currentMino: model.currentMino,
                          futureMino: model.futureMino,
                          fixedMino: model.fixedMino,
                        ),
                      ),
                    ),
                  ),
                  SizedBox.expand(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MaterialButton(
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
                                ],
                              ),
                              MaterialButton(
                                minWidth: 12,
                                onPressed: () {
                                  model.hardDrop();
                                },
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                shape: CircleBorder(),
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Row(
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
                            ],
                          ),
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
                      ? Container(
                          color: Colors.brown.withOpacity(0.2),
                          child: Center(
                            child: Text(
                              model.count != 0
                                  ? model.count.toString()
                                  : 'GO!!',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[900],
                              ),
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
