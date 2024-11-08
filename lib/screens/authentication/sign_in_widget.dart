import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:music_manager/shared/loading_widget.dart';
import 'package:music_manager/services/authentication/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';

// ignore: must_be_immutable
class SignInWidget extends StatefulWidget {
  String? errorMsg;
  SignInWidget({super.key, this.errorMsg});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Material(
            color: Colors.black,
            child: Loading(
              textToDisplay: "Please Wait...",
              loaderColor: Color.fromARGB(255, 181, 181, 181),
            ),
          )
        : Material(
            color: Colors.black,
            child: Container(
              decoration: CustomBackgroundGradientStyles.applicationBackground(
                  context.read<GradientBackgroundTheme>().bgThemeType),
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage('assets/gramophone.png'),
                            fit: BoxFit.contain,
                            width: 100,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "MusikQ",
                          style: GoogleFonts.berkshireSwash(
                              fontSize: 33,
                              color: Color.fromARGB(255, 239, 239, 239)),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     "Login to your account",
                      //     style: CustomTextStyles.normalTexts
                      //         .copyWith(color: Colors.white),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      ElevatedButton.icon(
                        icon: FaIcon(FontAwesomeIcons.google,
                            color: Color.fromARGB(255, 33, 33, 33)),
                        onPressed: () async {
                          setState(() => loading = true);
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          var loginResult =
                              await provider.googleLogin(context: context);
                          debugPrint(">> LoginResult variable = $loginResult");
                          setState(() => loading = false);
                          // if (loginResult == null) {
                          // setState(() => loading = false);
                          // }
                          // setState(() => loading = false);
                        },
                        label: Text(
                          "Sign In with Google",
                          style: CustomTextStyles.normalTexts.copyWith(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 237, 237, 237),
                          minimumSize: Size(double.infinity, 45),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (widget.errorMsg != null)
                          ? Text(
                              'Error: ${widget.errorMsg}',
                              style: CustomTextStyles.normalTexts
                                  .copyWith(color: Colors.white),
                            )
                          : Container()
                    ]),
              ),
            ),
          );
  }
}
