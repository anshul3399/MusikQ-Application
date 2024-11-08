import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Loading extends StatelessWidget {
  String textToDisplay;

  Color loaderColor = Color.fromARGB(255, 181, 181, 181);
  Loading(
      {super.key,
      required this.textToDisplay,
      this.loaderColor = const Color.fromARGB(255, 181, 181, 181)});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        decoration: CustomBackgroundGradientStyles.applicationBackground(
            context.read<GradientBackgroundTheme>().bgThemeType),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textToDisplay,
                style: CustomTextStyles.normalTexts
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
              SizedBox(
                height: 8,
              ),
              SpinKitChasingDots(
                color: loaderColor,
                size: 55.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
