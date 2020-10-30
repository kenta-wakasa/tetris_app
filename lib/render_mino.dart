import 'package:flutter/material.dart';

class RenderMino extends CustomPainter {
  final double basis = 20;
  List<List<int>> currentMino = [];
  List<List<int>> fixedMino = [];

  RenderMino({
    @required this.currentMino,
    @required this.fixedMino,
  });

  // 実際の描画処理を行うメソッド
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.blue;

    currentMino.forEach(
      (element) {
        canvas.drawRect(
            Rect.fromLTWH(element[0] * basis, element[1] * basis, basis, basis),
            paint);
      },
    );

    paint.color = Colors.red;
    fixedMino.forEach(
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
