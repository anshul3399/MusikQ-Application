import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_manager/screens/primaryScreens/operations_and_configurations_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/services/authentication/auth.dart';
import 'package:music_manager/services/model/app_configuration.dart';
import 'package:music_manager/services/model/app_user.dart';
import 'package:music_manager/services/model/songs_database.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SecurityPinView extends StatefulWidget {
  const SecurityPinView({super.key});

  @override
  State<SecurityPinView> createState() => _SecurityPinViewState();
}

class _SecurityPinViewState extends State<SecurityPinView> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  bool isUserAuthenticated = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appConfigData = Provider.of<AppConfiguration>(context);
    final userData = Provider.of<UserData>(context);

    return Material(
      color: Colors.black,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
        decoration: CustomBackgroundGradientStyles.applicationBackground(
            context.read<GradientBackgroundTheme>().bgThemeType),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/illustrations/authentication_pin.svg',
                    width: 150.0,
                    height: 150.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter the PIN",
                    style: GoogleFonts.josefinSans(
                      fontSize: 15,
                      height: 1.3,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: formKey,
                    child: PinCodeTextField(
                      appContext: context,
                      controller: textEditingController,
                      errorAnimationController: errorController,
                      length: 5,
                      cursorHeight: 19,
                      cursorColor: Colors.black,
                      obscureText: true,
                      obscuringCharacter: '*',
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      textStyle: GoogleFonts.josefinSans(
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w400),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v!.length < 3) {
                      //     return "Validator Text";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldWidth: 50,

                        // border color of box in which value is yet to be filled
                        inactiveColor: Color.fromARGB(255, 104, 104, 104),
                        // border color of box in which value is being filled
                        selectedColor: Color.fromARGB(255, 255, 255, 255),
                        // border color of box in which value is filled
                        activeColor: hasError
                            ? Color.fromARGB(255, 244, 123, 57)
                            : Colors.white,
                        // fill color of box in which value is yet to be filled
                        inactiveFillColor: Colors.transparent,
                        // fill color of box in which value is being filled
                        selectedFillColor: Color.fromARGB(255, 255, 255, 255),
                        // fill color of box in which value is filled
                        activeFillColor: Color.fromARGB(245, 251, 251, 251),

                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      animationDuration: Duration(milliseconds: 300),

                      hapticFeedbackTypes:
                          HapticFeedbackTypes.vibrate, // PinTheme
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError
                          ? (appConfigData.appAccessKey !=
                                  userData.appAccessKey)
                              ? "*access key mismatch error"
                              : (appConfigData.deleteDB ||
                                      userData.remotelyDeleteDB)
                                  ? "*could not perform any database related operation, remote deletion enabled ${(userData.remotelyDeleteDB) ? 'for this user' : 'globally'}"
                                  : "*PIN doesn't match"
                          : "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Color.fromARGB(243, 238, 121, 113),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: Size(50, 40)),
                          onPressed: () {
                            textEditingController.clear();
                            hasError = false;
                          },
                          icon: Icon(
                            Icons.clear_all_rounded,
                            size: 20,
                          ),
                          label: Text(
                            "Clear",
                            style: GoogleFonts.jost(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              minimumSize: Size(80, 40)),
                          onPressed: () {
                            formKey.currentState?.validate();
                            // conditions for validating
                            if ((appConfigData.appAccessKey !=
                                    userData.appAccessKey) ||
                                (currentText.length != 5 ||
                                    currentText != appConfigData.accessPIN) ||
                                (appConfigData.deleteDB == true ||
                                    userData.remotelyDeleteDB == true)) {
                              errorController.add(ErrorAnimationType
                                  .shake); // Triggering error shake animation
                              setState(() {
                                hasError = true;
                              });
                            } else {
                              setState(() {
                                hasError = false;
                                isUserAuthenticated = true;
                                debugPrint(">>>> All Conditions correct!!!!");
                              });
                            }
                            if (isUserAuthenticated) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return OperationsAndConfigurationsView();
                              }));
                            }
                          },
                          icon: Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                          ),
                          label: Text(
                            "Validate",
                            style: GoogleFonts.jost(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Color.fromARGB(255, 174, 174, 174),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(3.8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1.5,
                              color: Color.fromARGB(255, 122, 122, 122),
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                FirebaseAuth.instance.currentUser!.photoURL!),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                FirebaseAuth.instance.currentUser!.displayName!,
                                style: GoogleFonts.jost(
                                    color: Color.fromARGB(255, 209, 207, 207),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(
                              height: 2,
                            ),
                            Text(FirebaseAuth.instance.currentUser!.email!,
                                style: GoogleFonts.jost(
                                    color: Color.fromARGB(255, 209, 207, 207),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor:
                                  Color.fromARGB(255, 235, 235, 235),
                              foregroundColor: Colors.black,
                              minimumSize: Size(double.infinity, 40)),
                          onPressed: () async {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            await provider.googleLogout();
                            // Delete the stored local 'songs.db' on logout of the user
                            await SongsDatabase.instance
                                .deleteSongsDB('songs.db', showToastMsg: false);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            Icons.logout_rounded,
                            size: 20,
                          ),
                          label: Text(
                            "Logout",
                            style: GoogleFonts.jost(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    (appConfigData.appAccessKey != userData.appAccessKey)
                        ? Center(
                            //TODO: to modify the below rich text and the text inside it technically
                            child: RichText(
                            text: TextSpan(
                                text:
                                    'Access key token associated with the account ',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    height: 1.3,
                                    fontWeight: FontWeight.w300),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '"${userData.email}"',
                                    style: GoogleFonts.ibmPlexMono(
                                      color: Color.fromARGB(255, 223, 223, 223),
                                      fontSize: 13,
                                      height: 1.3,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                      text:
                                          " doesn't match with the app configuration access key.\nToken might have been expired or recasted.\nTry reinitialising the token from database.",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          height: 1.3,
                                          fontWeight: FontWeight.w300)),
                                  TextSpan(
                                      text:
                                          '\nAuthentication Provider: OAuth 2.0 Service\nEncryption Scheme: AES with 2048-bit RSA key\nHash Function: SHA256 bit\nDigital Certificates: CA95x7Ek314Q',
                                      style: GoogleFonts.ibmPlexMono(
                                          color: Color.fromARGB(
                                              255, 127, 127, 127),
                                          fontSize: 13,
                                          height: 1.3,
                                          fontWeight: FontWeight.w300))
                                ]),
                          ))
                        : Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
