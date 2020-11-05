import 'dart:async';
import 'package:flutter/material.dart';
import 'mino.dart';

class PlayModel extends ChangeNotifier {
  Timer _countDownTimer;
  Timer _mainTimer;
  int count = 3;
  int xPos = 0;
  int yPos = 0;
  int yPosFuture = 0;
  int angle = 0;
  int index = -1;
  int indexMino = 0;
  List<int> nextMinoList = [-1, -1, -1, -1];
  int indexHold = -1;
  bool usedHold = false;
  bool gameOver = false;
  List<int> orderMino = List(14);
  List<int> orderMinoFront = [0, 1, 2, 3, 4, 5, 6];
  List<int> orderMinoBack = [0, 1, 2, 3, 4, 5, 6];
  List<List<int>> currentMino = [];
  List<List<int>> futureMino = [];
  List<List<int>> fixedMino = [];

  countDown() {
    gameOver = false;
    count = 3;
    _countDownTimer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        count -= 1;
        if (count == -1) {
          _countDownTimer.cancel();
          startPlay();
        }
        notifyListeners();
      },
    );
  }

  startPlay() {
    _generateMino();
    _mainTimer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
      moveDown();
    });
  }

  reset() {
    yPos = 0;
    xPos = 0;
    index = -1;
    indexHold = -1;
    angle = 0;
    nextMinoList.clear();
    fixedMino.clear();
    currentMino.clear();
    futureMino.clear();
    _mainTimer.cancel();
    notifyListeners();
  }

  moveLeft() {
    xPos -= 1;
    _updateCurrentMino();
    if (_onCollisionEnter(currentMino)) {
      xPos += 1;
      _updateCurrentMino();
    }
    notifyListeners();
  }

  moveRight() {
    xPos += 1;
    _updateCurrentMino();
    if (_onCollisionEnter(currentMino)) {
      xPos -= 1;
      _updateCurrentMino();
    }
    notifyListeners();
  }

  moveDown() {
    yPos += 1;
    _updateCurrentMino();
    if (_onCollisionEnter(currentMino)) {
      yPos -= 1;
      _updateCurrentMino();
      for (List<int> e in currentMino) {
        fixedMino.add([e[0], e[1]]);
      }
      _gameOver();
      _deleteMino();
      _generateMino();
      _updateCurrentMino();
    }
    notifyListeners();
  }

  bool moveXY(int dx, int dy) {
    xPos += dx;
    yPos += dy;
    _updateCurrentMino();
    if (_onCollisionEnter(currentMino)) {
      xPos -= dx;
      yPos -= dy;
      _updateCurrentMino();
      notifyListeners();
      return false;
    } else {
      notifyListeners();
      return true;
    }
  }

  rotateLeft() {
    final _temporaryAngle = angle;
    angle = (angle + (1 * 90)) % 360;
    _updateCurrentMino();
    // 回転したとき他の障害部に当たった場合
    // SRS(スーパーローテーションシステム)に従いミノを移動させる
    // 参考: https://tetrisch.github.io/main/srs.html
    if (_onCollisionEnter(currentMino)) {
      // iMinoかどうかで分岐
      if (indexMino == 0) {
        // angleで分岐
        switch (angle) {
          case 0:
            if (moveXY(2, 0)) return 0;
            if (moveXY(-1, 0)) return 0;
            if (moveXY(2, -1)) return 0;
            if (moveXY(-1, 2)) return 0;
            break;
          case 90:
            if (moveXY(-1, 0)) return 0;
            if (moveXY(2, 0)) return 0;
            if (moveXY(-1, 1)) return 0;
            if (moveXY(2, 1)) return 0;
            break;
          case 180:
            if (moveXY(1, 0)) return 0;
            if (moveXY(-2, 0)) return 0;
            if (moveXY(-2, 1)) return 0;
            if (moveXY(1, -2)) return 0;
            break;
          case 270:
            if (moveXY(1, 0)) return 0;
            if (moveXY(-2, 0)) return 0;
            if (moveXY(1, 2)) return 0;
            if (moveXY(-2, -1)) return 0;
            break;
        }
      } else {
        // angleで分岐
        switch (angle) {
          case 0:
            if (moveXY(1, 0)) return 0;
            if (moveXY(1, 1)) return 0;
            if (moveXY(0, -1)) return 0;
            if (moveXY(1, -1)) return 0;
            break;
          case 90:
            if (moveXY(1, 0)) return 0;
            if (moveXY(1, -1)) return 0;
            if (moveXY(0, 1)) return 0;
            if (moveXY(1, 1)) return 0;
            break;
          case 180:
            if (moveXY(-1, 0)) return 0;
            if (moveXY(-1, 1)) return 0;
            if (moveXY(0, -1)) return 0;
            if (moveXY(-1, -1)) return 0;
            break;
          case 270:
            if (moveXY(-1, 0)) return 0;
            if (moveXY(-1, -1)) return 0;
            if (moveXY(0, 1)) return 0;
            if (moveXY(-1, 1)) return 0;
            break;
        }
      }
      // どこにも動かせなかった場合角度を戻す
      angle = _temporaryAngle;
      _updateCurrentMino();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  rotateRight() {
    final _temporaryAngle = angle;
    angle = (angle + (3 * 90)) % 360;
    _updateCurrentMino();
    // 回転したとき他の障害部に当たった場合
    // SRS(スーパーローテーションシステム)に従いミノを移動させる
    // 参考: https://tetrisch.github.io/main/srs.html
    if (_onCollisionEnter(currentMino)) {
      // iMinoかどうかで分岐
      if (indexMino == 0) {
        // angleで分岐
        switch (angle) {
          case 0:
            if (moveXY(-2, 0)) return 0;
            if (moveXY(1, 0)) return 0;
            if (moveXY(2, 1)) return 0;
            if (moveXY(-2, -1)) return 0;
            break;
          case 90:
            if (moveXY(2, 0)) return 0;
            if (moveXY(-1, 0)) return 0;
            if (moveXY(2, -1)) return 0;
            if (moveXY(-1, 2)) return 0;
            break;
          case 180:
            if (moveXY(-1, 0)) return 0;
            if (moveXY(2, 0)) return 0;
            if (moveXY(-1, 2)) return 0;
            if (moveXY(2, -1)) return 0;
            break;
          case 270:
            if (moveXY(2, 0)) return 0;
            if (moveXY(-1, 0)) return 0;
            if (moveXY(2, -1)) return 0;
            if (moveXY(-1, 2)) return 0;
            break;
        }
      } else {
        // angleで分岐
        switch (angle) {
          case 0:
            if (moveXY(-1, 0)) return 0;
            if (moveXY(-1, 1)) return 0;
            if (moveXY(0, -1)) return 0;
            if (moveXY(-1, -1)) return 0;
            break;
          case 90:
            if (moveXY(1, 0)) return 0;
            if (moveXY(1, -1)) return 0;
            if (moveXY(0, 1)) return 0;
            if (moveXY(1, 1)) return 0;
            break;
          case 180:
            if (moveXY(1, 0)) return 0;
            if (moveXY(1, 1)) return 0;
            if (moveXY(0, -1)) return 0;
            if (moveXY(1, 1)) return 0;
            break;
          case 270:
            if (moveXY(-1, 0)) return 0;
            if (moveXY(-1, -1)) return 0;
            if (moveXY(0, 1)) return 0;
            if (moveXY(-1, 1)) return 0;
            break;
        }
      }
      // どこにも動かせなかった場合角度を戻す
      angle = _temporaryAngle;
      _updateCurrentMino();
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  hardDrop() {
    for (List<int> e in futureMino) {
      fixedMino.add([e[0], e[1]]);
    }
    _generateMino();
    _updateCurrentMino();
    _deleteMino();
    _gameOver();
    notifyListeners();
  }

  holdMino() {
    if (usedHold) {
    } else {
      int _indexMino;
      _indexMino = indexMino;
      if (-1 < indexHold) {
        indexMino = indexHold;
        indexHold = _indexMino;
        yPos = 0;
        xPos = 0;
        angle = 0;
        _updateCurrentMino();
        notifyListeners();
      } else {
        indexHold = _indexMino;
        _generateMino();
      }
      usedHold = true;
    }
  }

  // game over 判定
  _gameOver() {
    if (fixedMino.where((element) => element[1] == -1).isNotEmpty) {
      _mainTimer.cancel();
      gameOver = true;
    }
  }

  _generateMino() {
    // 初期化
    if (index == -1) {
      orderMinoFront.shuffle();
      orderMino = [...orderMinoFront, ...orderMinoBack];
      index++;
    }
    // 0番目のときに 7~13番目をシャッフル
    if ((index % 14) == 0) {
      orderMinoBack.shuffle();
      orderMino = [...orderMinoFront, ...orderMinoBack];
    }
    // 7番目のときに 0~6番目をシャッフル
    if ((index % 14) == 7) {
      orderMinoFront.shuffle();
      orderMino = [...orderMinoFront, ...orderMinoBack];
    }
    yPos = 0;
    xPos = 0;
    angle = 0;
    indexMino = orderMino[index % 14];
    nextMinoList = [
      orderMino[(index + 1) % 14],
      orderMino[(index + 2) % 14],
      orderMino[(index + 3) % 14],
      orderMino[(index + 4) % 14],
    ];
    index += 1;
    usedHold = false;
    _updateCurrentMino();
    notifyListeners();
  }

  // コリジョン情報更新
  _updateCurrentMino() {
    if (currentMino.isEmpty) {
      currentMino = [
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0],
      ];
    }
    Mino.mino[indexMino][angle].asMap().forEach(
      (index, value) {
        currentMino[index][0] = value[0] + xPos;
        currentMino[index][1] = value[1] + yPos;
      },
    );
    // 必ずupdateの後に呼ぶ
    _predictDropPos();
  }

  // predict drop position
  _predictDropPos() {
    bool _enter = false;
    if (futureMino.isEmpty) {
      futureMino = [
        [0, 0],
        [0, 0],
        [0, 0],
        [0, 0],
      ];
    }
    yPosFuture = yPos;
    while (_enter == false) {
      yPosFuture++;
      Mino.mino[indexMino][angle].asMap().forEach(
        (index, value) {
          futureMino[index][0] = value[0] + xPos;
          futureMino[index][1] = value[1] + yPosFuture;
        },
      );
      // 衝突が判定されたらひとつ手前を描画してやめる
      if (_onCollisionEnter(futureMino)) {
        futureMino.forEach((element) {
          element[1]--;
        });
        _enter = true;
        notifyListeners();
      }
    }
  }

  // 衝突判定
  bool _onCollisionEnter(List<List<int>> mino) {
    bool _onCollisionEnter = false;
    mino.forEach(
      (element) {
        if (element[0] < -5 || 4 < element[0] || 19 < element[1]) {
          _onCollisionEnter = true;
        }
        for (List<int> eFixedMino in fixedMino) {
          if (eFixedMino[0] == element[0] && eFixedMino[1] == element[1]) {
            _onCollisionEnter = true;
          }
        }
      },
    );
    return _onCollisionEnter;
  }

  // 消滅判定
  _deleteMino() {
    List<int> _countCell = List.filled(20, 0);
    _countCell.asMap().forEach(
      (index, value) {
        // verify if there are 10 mino in row
        if (fixedMino.where((element) => element[1] == index).length == 10) {
          // delete row
          fixedMino.removeWhere((element) => element[1] == index);
          // drop upper mino
          fixedMino.where((element) => element[1] < index).forEach((element) {
            element[1] += 1;
          });
        }
      },
    );
  }
}
