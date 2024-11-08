import 'dart:math';
import 'package:flutter/material.dart';

class GradientBackgroundTheme with ChangeNotifier {
  int _bgThemeType = Random().nextInt(2);

  int get bgThemeType => _bgThemeType;

  void changeBackgroundTheme() {
    _bgThemeType = Random().nextInt(2);
    notifyListeners();
  }

  void setToYellowOrange() {
    _bgThemeType = 1;
    notifyListeners();
  }

  void setToPurpleBlack() {
    _bgThemeType = 2;
    notifyListeners();
  }
}
