import 'package:flutter/material.dart';

class Jmino extends CustomPainter {
  double yPos;
  double xPos;
  double angle;

  Jmino({
    this.yPos = 0,
    this.xPos = 0,
    this.angle = 0,
  });

  // 実際の描画処理を行うメソッド
  @override
  void paint(Canvas canvas, Size size) {
    // ここに描画の処理を書く
    final paint = Paint();
    const double basis = 24;
    paint.color = Colors.blue;
    canvas.translate(
      (xPos - 0.5) * basis,
      (yPos + 0.5) * basis,
    ); // 移動
    canvas.rotate(angle);
    canvas.drawRect(
        Rect.fromLTWH(-1.5 * basis, -1.5 * basis, basis, basis), paint);
    canvas.drawRect(
        Rect.fromLTWH(-1.5 * basis, -0.5 * basis, basis, basis), paint);
    canvas.drawRect(
        Rect.fromLTWH(-0.5 * basis, -0.5 * basis, basis, basis), paint);
    canvas.drawRect(
        Rect.fromLTWH(0.5 * basis, -0.5 * basis, basis, basis), paint);
  }

  // 再描画のタイミングで呼ばれるメソッド
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
