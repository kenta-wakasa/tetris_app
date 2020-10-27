import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetris_app/main_model.dart';
import 'mino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel(),
      child: Consumer<MainModel>(builder: (context, model, child) {
        return MaterialApp(
          title: 'TETRIS',
          theme: ThemeData(
            primarySwatch: Colors.blue,
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
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: 240,
                      height: 480,
                      color: Colors.grey,
                      child: CustomPaint(
                        painter: Jmino(xPos: 0, yPos: model.yPos, angle: 0),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        child: Text('Start'),
                        onPressed: () {
                          model.startTimer();
                        },
                      ),
                      RaisedButton(
                        child: Text('Stop'),
                        onPressed: () {
                          model.stopTimer();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
