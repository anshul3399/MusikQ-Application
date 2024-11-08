import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AccessKeyMismatchError extends StatefulWidget {
  const AccessKeyMismatchError({super.key});

  @override
  State<AccessKeyMismatchError> createState() => _AccessKeyMismatchErrorState();
}

class _AccessKeyMismatchErrorState extends State<AccessKeyMismatchError> {
  static const List<String> illustrationsPath = [
    'assets/illustrations/authorisation_error_1.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            illustrationsPath[Random().nextInt(illustrationsPath.length)],
            width: 150.0,
            height: 150.0,
          ),
          SizedBox(
            height: 15,
          ),
          // Container(
          //   height: 40,
          //   width: 40,
          //   decoration: BoxDecoration(
          //     color: Colors.transparent,
          //     image: DecorationImage(
          //       image: AssetImage("assets/guitar.png"),
          //       fit: BoxFit.fitWidth,
          //       alignment: Alignment.topCenter,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 10, 25, 10),
            child: Text(
              "Authorisation Error, the key signature is invalid",
              textAlign: TextAlign.justify,
              style: GoogleFonts.josefinSans(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
