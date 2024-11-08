import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/screens/primaryScreens/filtered_result_list.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import 'package:music_manager/services/sheets%20api/sheets_api.dart';
import 'package:music_manager/services/model/songs_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:music_manager/shared/loading_widget.dart';

// ignore: must_be_immutable
class OperationsAndConfigurationsView extends StatefulWidget {
  const OperationsAndConfigurationsView({super.key});

  @override
  State<OperationsAndConfigurationsView> createState() =>
      _OperationsAndConfigurationsViewState();
}

class _OperationsAndConfigurationsViewState
    extends State<OperationsAndConfigurationsView> {
  Future<int> initialiseSheet() async {
    await SheetsApi.init();
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    bool fetchAndAddPressed = false;
    String fetchBtnText = "Fetch Data from Online & Add into local DB";
    double fetchBtnWidth = 150;

    return FutureBuilder(
      builder: (context, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            return Container(
              padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
              decoration: CustomBackgroundGradientStyles.applicationBackground(
                  context.read<GradientBackgroundTheme>().bgThemeType),
              alignment: Alignment.topLeft,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 67, 67, 67),
                            foregroundColor: Color.fromARGB(255, 220, 220, 220),
                            minimumSize: Size(fetchBtnWidth, 40),
                            elevation: 0.0,
                            shape: StadiumBorder()),
                        onPressed: () async {
                          await SongsDatabase.instance
                              .deleteSongsDB('songs.db');
                          setState(() {
                            fetchAndAddPressed = true;
                            fetchBtnText = "Fetching & Adding..";
                            fetchBtnWidth = 100.0;
                          });
                          List<SongData>? songsDB =
                              await SheetsApi.getAllRows();
                          // debugPrint(">>> Inside OperationsAndConfigurationsView Data = ${songsDB}");
                          for (int i = 0; i < songsDB!.length; i++) {
                            await SongsDatabase.instance.create(songsDB[i]);
                            setState((() {
                              fetchBtnText =
                                  "${songsDB[i].songID}\tFetching & Adding..";
                            }));
                            debugPrint(
                                ">> Added Item in DB: ${songsDB[i].songID} -> ${songsDB[i].songTitle}");
                          }
                          setState(() {
                            fetchAndAddPressed = false;
                            fetchBtnText =
                                "Fetch Data from Online & Add into local DB";
                            fetchBtnWidth = 150.0;
                          });
                          if (mounted) {
                            showRestartDialogBox(context,
                                titleMsg: 'Restart Required',
                                descriptionMsg:
                                    'The database was reinitialised, updated data may have been populated. Please restart the app to reflect changes.');
                          }

                          // showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (BuildContext context) {
                          //       return Dialog(
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(20),
                          //         ),
                          //         elevation: 10,
                          //         backgroundColor: Colors.transparent,
                          //         child: contentBox(context),
                          //       );
                          //     });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (fetchAndAddPressed == true)
                                ? SpinKitChasingDots(
                                    color: Color.fromARGB(255, 210, 210, 210),
                                    size: 12.0,
                                  )
                                : Container(),
                            SizedBox(
                              width: 3,
                            ),
                            Text(fetchBtnText,
                                style: GoogleFonts.jost(
                                    fontWeight: FontWeight.w400, fontSize: 14)),
                          ],
                        ),
                      );
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 67, 67, 67),
                          foregroundColor: Color.fromARGB(255, 220, 220, 220),
                          minimumSize: const Size(150, 40),
                          elevation: 0.0,
                          shape: StadiumBorder()),
                      onPressed: () async {
                        List<SongData> returnedDataFromDB =
                            await SongsDatabase.instance.readAllSongs();
                        for (int i = 0; i < returnedDataFromDB.length; i++) {
                          debugPrint(
                              ">> Items in DB: ${returnedDataFromDB[i].songID} -- ${returnedDataFromDB[i].songTitle}");
                        }
                        debugPrint(
                            ">> Total Returned Data from database: ${returnedDataFromDB.length}");
                      },
                      child: Text('Get All Data from Local Storage',
                          style: GoogleFonts.jost(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Get from specific ID
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 67, 67, 67),
                          foregroundColor: Color.fromARGB(255, 220, 220, 220),
                          minimumSize: const Size(150, 40),
                          elevation: 0.0,
                          shape: StadiumBorder()),
                      onPressed: () async {
                        SongData returnedDataFromDB = await SongsDatabase
                            .instance
                            .readNode('at_xxf3f672');

                        debugPrint(
                            ">> Items in DB: ${returnedDataFromDB.songID} -- ${returnedDataFromDB.songTitle}, Singers-${returnedDataFromDB.singers}");
                      },
                      child: Text('Get Specific data from Local Storage',
                          style: GoogleFonts.jost(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // Fire query on Local Database Songs DB
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 67, 67, 67),
                          foregroundColor: Color.fromARGB(255, 220, 220, 220),
                          minimumSize: const Size(150, 40),
                          elevation: 0.0,
                          shape: StadiumBorder()),
                      onPressed: () async {
                        List<SongData> filteredResultList =
                            await SongsDatabase.instance.queryDatabase();
                        if (mounted) {
                          _navigateToNextScreen(context, filteredResultList);
                        }
                      },
                      child: Text('Fire Query on Local DB',
                          style: GoogleFonts.jost(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // Get distinct years form Local Database Songs DB
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 67, 67, 67),
                          foregroundColor: Color.fromARGB(255, 220, 220, 220),
                          minimumSize: const Size(150, 40),
                          elevation: 0.0,
                          shape: StadiumBorder()),
                      onPressed: () async {
                        List distinctLyricist = await SongsDatabase.instance
                            .queryForDistinctConsolidatedvalues('Lyricist');
                        debugPrint(">> Distinct Lyricist: $distinctLyricist");
                      },
                      child: Text('Get distinct Lyricists',
                          style: GoogleFonts.jost(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // Delete Songs DB
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 67, 67, 67),
                          foregroundColor: Color.fromARGB(255, 220, 220, 220),
                          minimumSize: const Size(150, 40),
                          elevation: 0.0,
                          shape: StadiumBorder()),
                      onPressed: () async {
                        await SongsDatabase.instance.deleteSongsDB('songs.db');
                        if (mounted) {
                          showRestartDialogBox(context,
                              titleMsg: 'Restart Required',
                              descriptionMsg:
                                  'The database was deleted. Please restart the app to the reflect changes.');
                        }
                      },
                      child: Text('Delete Songs DB from Local Storage',
                          style: GoogleFonts.jost(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        // Displaying LoadingSpinner to indicate waiting state
        return Loading(textToDisplay: "Initialising Sheet..");
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: initialiseSheet(),
    );
  }

  void _navigateToNextScreen(BuildContext context, List<SongData> list) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FilteredResultListView(
              filteredResultList: list,
            )));
  }
}

void showRestartDialogBox(BuildContext context,
    {required String titleMsg, required String descriptionMsg}) {
  bool restartBtnPressed = false;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: 20, top: 30 + 20, right: 20, bottom: 20),
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: // Grey-Black Gradient
                        const [
                      Color.fromARGB(255, 40, 40, 40),
                      Color.fromARGB(255, 28, 28, 28),
                      Colors.black
                    ],
                    stops: const [0.16, 0.5, 0.9],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      titleMsg,
                      style: GoogleFonts.jost(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 1.7,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      descriptionMsg,
                      style: GoogleFonts.jost(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromARGB(255, 216, 216, 216)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            restartBtnPressed = true;
                            Restart.restartApp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (restartBtnPressed == false)
                                ? Colors.transparent
                                : Colors.white,
                            foregroundColor: (restartBtnPressed == false)
                                ? Colors.white
                                : Colors.black,
                            side: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(70, 30),
                            // elevation: 5.0,
                          ),
                          child: Text('Restart',
                              style: GoogleFonts.jost(
                                  fontWeight: FontWeight.w400, fontSize: 15)),
                        )),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Image.asset("assets/gramophone.png")),
                ),
              ),
            ],
          ),
        );
      });
}

// contentBox(context) {
//   bool restartBtnPressed = false;
//   return Stack(
//     children: <Widget>[
//       Container(
//         padding: EdgeInsets.only(left: 20, top: 30 + 20, right: 20, bottom: 20),
//         margin: EdgeInsets.only(top: 30),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: LinearGradient(
//             colors: // Grey-Black Gradient
//                 const [
//               Color.fromARGB(255, 40, 40, 40),
//               Color.fromARGB(255, 28, 28, 28),
//               Colors.black
//             ],
//             stops: const [0.16, 0.5, 0.9],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(
//               'Restart Required',
//               style: GoogleFonts.jost(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 18,
//                   letterSpacing: 1.7,
//                   color: Colors.white),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               'The database was reinitialised, updated data may have been populated. Please restart the app to reflect changes.',
//               style: GoogleFonts.jost(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 14,
//                   color: Color.fromARGB(255, 216, 216, 216)),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Align(
//                 alignment: Alignment.bottomCenter,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     restartBtnPressed = true;
//                     Restart.restartApp();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: (restartBtnPressed == false)
//                         ? Colors.transparent
//                         : Colors.white,
//                     foregroundColor: (restartBtnPressed == false)
//                         ? Colors.white
//                         : Colors.black,
//                     side: BorderSide(
//                         width: 1, color: Color.fromARGB(255, 255, 255, 255)),
//                     shape: RoundedRectangleBorder(
//                       //to set border radius to button
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     minimumSize: const Size(70, 30),
//                     // elevation: 5.0,
//                   ),
//                   child: Text('Restart',
//                       style: GoogleFonts.jost(
//                           fontWeight: FontWeight.w400, fontSize: 15)),
//                 )),
//           ],
//         ),
//       ),
//       Positioned(
//         left: 20,
//         right: 20,
//         child: CircleAvatar(
//           backgroundColor: Colors.transparent,
//           radius: 30,
//           child: ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               child: Image.asset("assets/gramophone.png")),
//         ),
//       ),
//     ],
//   );
// }
