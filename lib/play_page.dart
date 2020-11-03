import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/play_model.dart';
import 'package:tetris_app/render_hold.dart';
import 'package:tetris_app/render_next.dart';
import 'package:tetris_app/start_page.dart';
import 'render_mino.dart';

class PlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _centerPos = _size.width / 2;
    final _inputSensitivity = 20;
    double _deltaLeft = 0;
    double _deltaRight = 0;
    double _deltaDown = 0;
    bool _hardDrop = false;
    bool _holdMino = false;
    return ChangeNotifierProvider<PlayModel>(
      create: (_) => PlayModel()..countDown(),
      child: Consumer<PlayModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'TETRIS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
              children: [
                // タップとドラッグの検知
                GestureDetector(
                  dragStartBehavior: DragStartBehavior.down,
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
                    _holdMino = false;
                    _deltaRight = 0;
                    _deltaLeft = 0;
                    _deltaDown = 0;
                  },
                  onPanUpdate: (details) {
                    // 移動処理
                    if (0 < details.delta.dx) {
                      _deltaRight += details.delta.dx;
                      if (_inputSensitivity < _deltaRight) {
                        model.moveRight();
                        _deltaRight = 0;
                      }
                    } else {
                      _deltaLeft += details.delta.dx.abs();
                      if (_inputSensitivity < _deltaLeft) {
                        model.moveLeft();
                        _deltaLeft = 0;
                      }
                    }
                    if (0 < details.delta.dy) {
                      _deltaDown += details.delta.dy;
                      if (_inputSensitivity < _deltaDown && !_hardDrop) {
                        model.moveDown();
                        _deltaDown = 0;
                      }
                    }
                    // hard drop 処理
                    if (_inputSensitivity + 10 < details.delta.dy &&
                        !_hardDrop) {
                      _hardDrop = true;
                      _deltaDown = 0;
                      model.hardDrop();
                    }
                    // hard drop 処理
                    if (-(_inputSensitivity + 10) > details.delta.dy &&
                        !_holdMino) {
                      _holdMino = true;
                      _deltaDown = 0;
                      model.holdMino();
                    }
                  },
                  child: Container(
                    color: Colors.white.withOpacity(0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('HOLD'),
                            CustomPaint(
                              painter: RenderHold(
                                usedHold: model.usedHold,
                                indexHold: model.indexHold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Text(''),
                            CustomPaint(
                              painter: RenderMino(
                                currentMino: model.currentMino,
                                futureMino: model.futureMino,
                                fixedMino: model.fixedMino,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NEXT'),
                            CustomPaint(
                              painter: RenderNext(
                                nextMinoList: model.nextMinoList,
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
                            model.count != 0 ? model.count.toString() : 'GO!!',
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
          );
        },
      ),
    );
  }
}
