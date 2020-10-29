import 'dart:math';

import 'package:flutter/material.dart';

class Jmino extends CustomPainter {
  double yPos;
  double xPos;
  double angle;

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

  List<List<double>> fixedMino;

  Jmino({
    this.yPos = 0,
    this.xPos = 0,
    this.angle = 0,
    this.fixedMino,
  });

  // 実際の描画処理を行うメソッド
  @override
  void paint(Canvas canvas, Size size) {
    // ここに描画の処理を書く
    final paint = Paint();
    const double basis = 24;
    paint.color = Colors.blue;
    this.jMinoCollision[angle].forEach(
      (element) {
        canvas.drawRect(
            Rect.fromLTWH((element[0] + xPos) * basis,
                (element[1] + yPos) * basis, basis, basis),
            paint);
      },
    );
    paint.color = Colors.red;
    this.fixedMino.forEach(
      (element) {
        canvas.drawRect(
            Rect.fromLTWH(element[0] * basis, element[1] * basis, basis, basis),
            paint);
      },
    );
  }

  // 再描画のタイミングで呼ばれるメソッド
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
