import 'dart:async';
import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  Timer timer;
  double yPos;

  startTimer() {
    print('start!');
    this.timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        print(t.tick);
        yPos = t.tick.toDouble();
        notifyListeners();
      },
    );
  }

  stopTimer() {
    print('stop!');
    this.timer.cancel();
    yPos = 0;
    notifyListeners();
  }
}
