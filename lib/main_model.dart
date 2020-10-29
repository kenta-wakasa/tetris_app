import 'dart:async';
import 'package:flutter/material.dart';
import 'mino.dart';

class MainModel extends ChangeNotifier {
  Timer timer;
  int yPos = 0;
  int xPos = 0;
  int angle = 0;
  int index = 0;
  int indexMino = 0;
  List<int> orderMino = [0, 1, 2, 3, 4, 5, 6];
  List<List<int>> nowCollision = [
    [0, 0],
    [0, 0],
    [0, 0],
    [0, 0]
  ];
  List<List<int>> fixedMino = [];

  startTimer() {
    _generateMino();
    this.timer = Timer.periodic(
      Duration(milliseconds: 200),
      (Timer t) {
        this.yPos += 1;
        if (_onCollisionEnter()) {
          //ToDo: ミノを固定する
          this.yPos -= 1;
          _updateCollision();
          for (List<int> e in nowCollision) {
            fixedMino.add([e[0], e[1]]);
          }
          _canDelete();
          _generateMino();
        }
        notifyListeners();
      },
    );
  }

  _generateMino() {
    if ((this.index % 7) == 0) {
      this.orderMino.shuffle();
    }
    this.yPos = 0;
    this.xPos = 0;
    this.angle = 0;
    this.indexMino = this.orderMino[this.index % 7];
    this.index += 1;
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
    this.xPos -= 1;
    if (_onCollisionEnter()) {
      this.xPos += 1;
    }
    notifyListeners();
  }

  moveRight() {
    this.xPos += 1;
    if (_onCollisionEnter()) {
      this.xPos -= 1;
    }
    notifyListeners();
  }

  rotateLeft() {
    this.angle = (this.angle + (1 * 90)) % 360;
    if (_onCollisionEnter()) {
      this.angle = (this.angle + (3 * 90)) % 360;
    }
    notifyListeners();
  }

  rotateRight() {
    this.angle = (this.angle + (3 * 90)) % 360;
    if (_onCollisionEnter()) {
      this.angle = (this.angle + (1 * 90)) % 360;
    }
    notifyListeners();
  }

  // コリジョン情報更新
  _updateCollision() {
    Mino.mino[indexMino][angle].asMap().forEach(
      (index, value) {
        this.nowCollision[index][0] = value[0] + this.xPos;
        this.nowCollision[index][1] = value[1] + this.yPos;
      },
    );
  }

  // 衝突判定
  bool _onCollisionEnter() {
    bool _onCollisionEnter = false;
    _updateCollision();
    nowCollision.forEach(
      (element) {
        if (element[0] < -5 || 4 < element[0] || 19 < element[1]) {
          _onCollisionEnter = true;
        }
        for (List<int> e in this.fixedMino) {
          if (e[0] == element[0] && e[1] == element[1]) {
            _onCollisionEnter = true;
          }
        }
      },
    );
    return _onCollisionEnter;
  }

  // 消滅判定
  _canDelete() {
    List<int> _countCell = List.filled(20, 0);
    _countCell.asMap().forEach(
      (index, value) {
        fixedMino.forEach((element) {
          if (element[1] == index) {
            value += 1;
            print([index, value]);
          }
        });
        if (value == 10) {
          print('delete!');
          print(fixedMino);
          fixedMino.removeWhere((element) => element[1] == index);
          fixedMino.where((element) => element[1] < index).forEach((element) {
            element[1] += 1;
          });
        }
      },
    );
  }
}
