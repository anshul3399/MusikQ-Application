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
    case 3:
      {
        // Spotify-inspired Dark Green Gradient
        return const [
          Color.fromARGB(255, 14, 35, 26),
          Color.fromARGB(255, 25, 61, 45),
          Color.fromARGB(255, 15, 23, 20),
          Colors.black
        ];
      }
    case 4:
      {
        // YouTube Music-inspired Dark Red Gradient
        return const [
          Color.fromARGB(255, 40, 12, 16),
          Color.fromARGB(255, 61, 18, 24),
          Color.fromARGB(255, 28, 8, 11),
          Colors.black
        ];
      }
    case 5:
      {
        // Apple Music-inspired Dark Rose Gradient
        return const [
          Color.fromARGB(255, 45, 15, 35),
          Color.fromARGB(255, 65, 20, 50),
          Color.fromARGB(255, 30, 10, 25),
          Colors.black
        ];
      }
    case 6:
      {
        // Royal Night Gradient
        return const [
          Color.fromARGB(255, 28, 20, 56), // Deep royal purple
          Color.fromARGB(255, 45, 35, 90), // Rich medium purple
          Color.fromARGB(255, 20, 15, 40), // Deep twilight purple
          Color.fromARGB(255, 10, 8, 20), // Near-black purple
        ];
      }
    case 7:
      {
        // Deep Ocean Gradient
        return const [
          Color.fromARGB(255, 15, 32, 39), // Deep teal
          Color.fromARGB(255, 25, 55, 67), // Rich ocean blue
          Color.fromARGB(255, 10, 20, 35), // Midnight blue
          Colors.black,
        ];
      }
    case 8:
      {
        // Aurora Borealis Dark
        return const [
          Color.fromARGB(255, 20, 42, 43), // Deep teal-green
          Color.fromARGB(255, 30, 45, 60), // Northern lights blue
          Color.fromARGB(255, 25, 35, 50), // Deep aurora purple
          Color.fromARGB(255, 8, 12, 20), // Night sky
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
        // DeepBlue-LitishBlue-LightPurple Gradient
        return const [0.0, 0.22, 0.34, 1.0];
      }
    case 3:
      {
        // Spotify-inspired Dark Green Gradient
        return const [0.15, 0.4, 0.7, 0.9];
      }
    case 4:
      {
        // YouTube Music-inspired Dark Red Gradient
        return const [0.1, 0.35, 0.65, 0.9];
      }
    case 5:
      {
        // Apple Music-inspired Dark Rose Gradient
        return const [0.2, 0.45, 0.75, 0.9];
      }
    case 6:
      {
        // Royal Night Gradient
        return const [0.1, 0.3, 0.6, 0.85];
      }
    case 7:
      {
        // Deep Ocean Gradient
        return const [0.15, 0.4, 0.7, 0.9];
      }
    case 8:
      {
        // Aurora Borealis Dark
        return const [0.2, 0.45, 0.7, 0.9];
      }
    default:
      {
        // Purple-Blue Gradient
        return const [0.13, 0.28, 0.65];
      }
  }
}
