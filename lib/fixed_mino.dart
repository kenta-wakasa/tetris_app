import 'package:flutter/material.dart';

class FixedMino extends CustomPainter {
  List<List<double>> fixedMino;
  FixedMino({this.fixedMino});

  // 実際の描画処理を行うメソッド
  @override
  void paint(Canvas canvas, Size size) {
    // ここに描画の処理を書く
    final paint = Paint();
    const double basis = 24;
    paint.color = Colors.red;
    this.fixedMino?.forEach(
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
