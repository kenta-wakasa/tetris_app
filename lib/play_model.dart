import 'dart:async';
import 'package:flutter/material.dart';
import 'mino.dart';

class PlayModel extends ChangeNotifier {
  Timer _countDownTimer;
  Timer _startTimer;
  int count = 3;
  int yPos = 0;
  int xPos = 0;
  int angle = 0;
  int index = 0;
  int indexMino = 0;
  bool gameOver = false;
  List<int> orderMino = [0, 1, 2, 3, 4, 5, 6];
  List<List<int>> currentMino = [];
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
    gameOver = false;
    _generateMino();
    _startTimer = Timer.periodic(
      Duration(milliseconds: 200),
      (Timer t) {
        yPos += 1;
        if (_onCollisionEnter()) {
          yPos -= 1;
          _updateMino();
          for (List<int> e in currentMino) {
            fixedMino.add([e[0], e[1]]);
          }
          _deleteMino();
          _generateMino();
        }
        _updateMino();
        if (fixedMino.where((element) => element[1] == -1).isNotEmpty) {
          _startTimer.cancel();
          gameOver = true;
        }
        notifyListeners();
      },
    );
  }

  _generateMino() {
    if ((index % 7) == 0) {
      orderMino.shuffle();
    }
    yPos = 0;
    xPos = 0;
    angle = 0;
    indexMino = orderMino[index % 7];
    index += 1;
    _updateMino();
    notifyListeners();
  }

  reset() {
    yPos = 0;
    xPos = 0;
    angle = 0;
    fixedMino.clear();
    currentMino.clear();
    _startTimer.cancel();
    notifyListeners();
  }

  moveLeft() {
    xPos -= 1;
    if (_onCollisionEnter()) {
      xPos += 1;
      _updateMino();
    }
    notifyListeners();
  }

  moveRight() {
    xPos += 1;
    if (_onCollisionEnter()) {
      xPos -= 1;
      _updateMino();
    }
    notifyListeners();
  }

  rotateLeft() {
    angle = (angle + (1 * 90)) % 360;
    if (_onCollisionEnter()) {
      angle = (angle + (3 * 90)) % 360;
      _updateMino();
    }
    notifyListeners();
  }

  rotateRight() {
    angle = (angle + (3 * 90)) % 360;
    if (_onCollisionEnter()) {
      angle = (angle + (1 * 90)) % 360;
      _updateMino();
    }
    notifyListeners();
  }

  // コリジョン情報更新
  _updateMino() {
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
  }

  // 衝突判定
  bool _onCollisionEnter() {
    bool _onCollisionEnter = false;
    _updateMino();
    currentMino.forEach(
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
