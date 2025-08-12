import 'dart:math';
import 'package:flutter/material.dart';

class GradientBackgroundTheme with ChangeNotifier {
  int _bgThemeType = Random().nextInt(8) + 1; // 1 to 8 inclusive

  //int get bgThemeType => 8; // Forcing to use a specific theme for testing
  int get bgThemeType => _bgThemeType;

  void changeBackgroundTheme() {
    _bgThemeType = Random().nextInt(8) + 1;
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
