import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  Timer timer;
  double yPos = 0;
  double xPos = 0;
  double angle = 0;

  List<List<double>> nowCollision = [
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0]
  ];

  List<List<double>> fixedMino = [];

  final Map<double, List<List<double>>> jMinoCollision = {
    0: [
      [-2, -1],
      [-2, 0],
      [-1, 0],
      [0, 0]
    ],
    pi / 2: [
      [-1, -1],
      [0, -1],
      [-1, 0],
      [-1, 1]
    ],
    pi: [
      [-2, 0],
      [-1, 0],
      [0, 0],
      [0, 1]
    ],
    (3 * pi) / 2: [
      [-1, -1],
      [-1, 0],
      [-2, 1],
      [-1, 1]
    ],
  };

  startTimer() async {
    this.timer = Timer.periodic(
      Duration(milliseconds: 200),
      (Timer t) {
        this.yPos += 1;
        if (_isOutOfRange()) {
          //ToDo: ミノを固定する
          this.yPos -= 1;
          _updateCollision();
          for (List<double> e in nowCollision) {
            fixedMino.add([e[0], e[1]]);
          }
          generateMino();
          print('add');
        }
        print(this.fixedMino);
        notifyListeners();
      },
    );
  }

  generateMino() {
    this.yPos = 0;
    this.xPos = 0;
    this.angle = 0;
    _updateCollision();
    notifyListeners();
  }

  reset() {
    this.yPos = 0;
    this.xPos = 0;
    this.angle = 0;
    this.fixedMino.clear();
    _updateCollision();
    notifyListeners();
  }

  moveLeft() {
    this.xPos -= 1.0;
    if (_isOutOfRange()) {
      this.xPos += 1.0;
    }
    notifyListeners();
  }

  moveRight() {
    this.xPos += 1.0;
    if (_isOutOfRange()) {
      this.xPos -= 1.0;
    }
    notifyListeners();
  }

  rotateRight() {
    this.angle += (3 * pi) / 2;
    this.angle = this.angle % (2 * pi);
    notifyListeners();
  }

  rotateLeft() {
    this.angle += pi / 2;
    this.angle = this.angle % (2 * pi);
    notifyListeners();
  }

  // コリジョン情報更新
  _updateCollision() {
    this.jMinoCollision[angle].asMap().forEach(
      (index, value) {
        this.nowCollision[index][0] = value[0] + this.xPos;
        this.nowCollision[index][1] = value[1] + this.yPos;
      },
    );
  }

  // 場外判定
  bool _isOutOfRange() {
    bool _isOutOfRange = false;
    _updateCollision();
    nowCollision.forEach(
      (element) {
        if (element[0] < -5 || 4 < element[0] || 19 < element[1]) {
          _isOutOfRange = true;
        }
      },
    );
    return _isOutOfRange;
  }
}
