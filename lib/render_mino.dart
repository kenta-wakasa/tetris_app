import 'package:flutter/material.dart';
import 'package:tetris_app/mino.dart';

class RenderMino extends CustomPainter {
  int yPos;
  int xPos;
  int angle;
  int indexMino;

  List<List<int>> fixedMino = [];

  RenderMino({
    this.yPos = 0,
    this.xPos = 0,
    this.angle = 0,
    this.indexMino = 0,
    this.fixedMino,
  });

  // 実際の描画処理を行うメソッド
  @override
  void paint(Canvas canvas, Size size) {
    // ここに描画の処理を書く
    final paint = Paint();
    const double basis = 20;
    paint.color = Colors.blue;
    Mino.mino[indexMino][angle].forEach(
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
