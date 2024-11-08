import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  static TextStyle headingsTextStyle = GoogleFonts.amita(
    fontSize: 22,
    color: Colors.white,
    fontWeight: FontWeight.w800,
  );

  static TextStyle normalTexts = GoogleFonts.marcellus(
      fontSize: 14, color: Color.fromARGB(255, 0, 0, 0), letterSpacing: 1.5);
}

SnackBar createCustomSnackBar(String snackbarMessage) {
  return SnackBar(
    content: Text(
      snackbarMessage,
      style: GoogleFonts.jost(
        color: Colors.white,
        fontSize: 13,
      ),
      textAlign: TextAlign.left,
    ),
    backgroundColor: Color.fromARGB(255, 50, 50, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16), // Round the top corners
      ),
    ),
    duration: Duration(seconds: 2),
  );
}

class CustomBackgroundGradientStyles {
  // Gradient Background for application
  static BoxDecoration applicationBackground(int bgThemeType) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: getBackgroundColors(bgThemeType),
        stops: getStopLimitsOfBGColors(bgThemeType),
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
      ),
    );
  }

  // Gradient Background for Filter Chip Animated Container
  static BoxDecoration filterChipsBackground = BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    gradient: LinearGradient(
      colors: // Grey-Black Gradient
          const [
        Color.fromARGB(172, 75, 75, 75),
        Color.fromARGB(179, 44, 44, 44),
        Colors.black
      ],
      stops: const [0.16, 0.6, 0.9],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}

getBackgroundColors(int bgThemeType) {
  switch (bgThemeType) {
    case 1:
      {
        // DeepYellow-Magenta Gradient
        return const [
          Color.fromARGB(255, 36, 11, 6),
          Color.fromARGB(255, 40, 32, 19),
          Colors.black
        ];
      }
    case 2:
      {
        // DeepBlue-LitishBlue-LightPurple Gradient
        return const [
          Color.fromARGB(255, 26, 49, 55),
          Color.fromARGB(255, 70, 64, 95),
          Color.fromARGB(255, 40, 65, 97),
          Colors.black
        ];
      }
    default:
      {
        // Purple-Blue Gradient
        return const [
          Color.fromARGB(238, 30, 11, 43),
          Color.fromARGB(242, 35, 10, 72),
          Colors.black
        ];
      }
  }
}

getStopLimitsOfBGColors(int bgThemeType) {
  switch (bgThemeType) {
    case 1:
      {
        // DeepYellow-Magenta Gradient
        return const [0.1, 0.3, 0.7];
      }
    case 2:
      {
        // DeepYellow-Magenta Gradient
        return const [0.0, 0.22, 0.34, 1.0];
      }
    default:
      {
        // Purple-Blue Gradient
        return const [0.13, 0.28, 0.65];
      }
  }
}
