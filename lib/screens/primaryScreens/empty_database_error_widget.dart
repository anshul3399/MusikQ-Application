import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class EmptyDatabaseError extends StatefulWidget {
  String msg;

  EmptyDatabaseError({super.key, required this.msg});

  @override
  State<EmptyDatabaseError> createState() => _EmptyDatabaseErrorState();
}

class _EmptyDatabaseErrorState extends State<EmptyDatabaseError> {
  static const List<String> illustrationsPath = [
    'assets/illustrations/add_some_data_1.svg', //TODO: change guitar color
    'assets/illustrations/add_some_data_2.svg',
    'assets/illustrations/add_some_data_3.svg',
    'assets/illustrations/add_some_data_4.svg',
    'assets/illustrations/add_some_data_5.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            illustrationsPath[Random().nextInt(illustrationsPath.length)],
            width: 150.0,
            height: 150.0,
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 5, 25, 10),
            child: Text(
              widget.msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.josefinSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1.2),
            ),
          )
        ],
      ),
    );
  }
}
