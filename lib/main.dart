import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TETRIS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('TETRIS'),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  alignment: Alignment.topCenter,
                  width: 240,
                  height: 480,
                  color: Colors.grey,
                  child: CustomPaint(
                    painter: _MyPainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  // ※ コンストラクタに引数を持たせたい場合はこんな感じで
  //double value;
  //_MyPainter(this.value);

  // 実際の描画処理を行うメソッド
  @override
  void paint(Canvas canvas, Size size) {
    // ここに描画の処理を書く
    final paint = Paint();
    paint.color = Colors.blue;
    canvas.drawRect(Rect.fromLTWH(-48, 0, 24, 24), paint);
    canvas.drawRect(Rect.fromLTWH(-48, 24, 24, 24), paint);
    canvas.drawRect(Rect.fromLTWH(-24, 24, 24, 24), paint);
    canvas.drawRect(Rect.fromLTWH(0, 24, 24, 24), paint);
  }

  // 再描画のタイミングで呼ばれるメソッド
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
