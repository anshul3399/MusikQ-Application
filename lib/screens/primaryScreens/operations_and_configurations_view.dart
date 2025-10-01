import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import "package:music_manager/services/sheets%20api/sheets_api.dart";
import 'package:music_manager/services/model/songs_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:music_manager/shared/loading_widget.dart';

class OperationsAndConfigurationsView extends StatefulWidget {
  const OperationsAndConfigurationsView({super.key});

  @override
  State<OperationsAndConfigurationsView> createState() =>
      _OperationsAndConfigurationsViewState();
}

class _OperationsAndConfigurationsViewState
    extends State<OperationsAndConfigurationsView> {
  bool _fetchAndAddPressed = false;
  String _fetchBtnText = "Fetch Data from Online & Add into local DB";

  Future<int> initialiseSheet() async {
    await SheetsApi.init();
    return 1;
  }

  Widget buildActionButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    bool isLoading = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SpinKitChasingDots(
                color: Colors.white,
                size: 20.0,
              )
            else
              Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  text,
                  style: GoogleFonts.jost(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showRestartDialogBox(
    BuildContext context, {
    required String titleMsg,
    required String descriptionMsg,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.black87,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Icon
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/app_icon.png'),
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  titleMsg,
                  style: GoogleFonts.jost(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  descriptionMsg,
                  style: GoogleFonts.jost(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Restart.restartApp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Restart Now',
                          style: GoogleFonts.jost(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: initialiseSheet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading(textToDisplay: "Initialising Sheet..");
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "${snapshot.error} occurred",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          decoration: CustomBackgroundGradientStyles.applicationBackground(
              context.read<GradientBackgroundTheme>().bgThemeType),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Actions Section
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Actions",
                            style: GoogleFonts.jost(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          buildActionButton(
                            onPressed: () async {
                              setState(() {
                                _fetchAndAddPressed = true;
                                _fetchBtnText = "Fetching & Adding..";
                              });

                              // Delete existing local DB before adding new entries
                              await SongsDatabase.instance
                                  .deleteSongsDB("songs.db");

                              // Attempt to fetch rows from Sheets API with retries on transient errors.
                              List<SongData>? songsDB =
                                  await SheetsApi.getAllRowsWithRetries(
                                      maxAttempts: 5);

                              // Handle null or empty response gracefully
                              if (songsDB == null || songsDB.isEmpty) {
                                if (mounted) {
                                  setState(() {
                                    _fetchAndAddPressed = false;
                                    _fetchBtnText =
                                        "Fetch Data from Online & Add into local DB";
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to fetch data from online source or no data available.',
                                        style: GoogleFonts.jost(),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }

                                return;
                              }

                              // Insert fetched songs into local DB in batches
                              const int batchSize = 100;
                              for (int start = 0;
                                  start < songsDB.length;
                                  start += batchSize) {
                                final end = (start + batchSize < songsDB.length)
                                    ? start + batchSize
                                    : songsDB.length;
                                final batch = songsDB.sublist(start, end);
                                await SongsDatabase.instance.createMany(batch);

                                if (mounted) {
                                  setState(() {
                                    _fetchBtnText =
                                        "Added ${start + batch.length} of ${songsDB.length} records...";
                                  });
                                }

                                // Small delay between batches to reduce burst traffic
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                              }

                              if (mounted) {
                                setState(() {
                                  _fetchAndAddPressed = false;
                                  _fetchBtnText =
                                      "Fetch Data from Online & Add into local DB";
                                });

                                showRestartDialogBox(
                                  context,
                                  titleMsg: "Restart Required",
                                  descriptionMsg:
                                      "The database was reinitialised, updated data may have been populated. Please restart the app to reflect changes.",
                                );
                              }
                            },
                            text: _fetchBtnText,
                            icon: Icons.cloud_download_rounded,
                            isLoading: _fetchAndAddPressed,
                          ),
                          buildActionButton(
                            onPressed: () async {
                              List<SongData> returnedDataFromDB =
                                  await SongsDatabase.instance.readAllSongs();
                              for (var song in returnedDataFromDB) {
                                debugPrint(
                                    ">> Items in DB: ${song.songID} -- ${song.songTitle}");
                              }
                              debugPrint(
                                  ">> Total Returned Data from database: ${returnedDataFromDB.length}");
                            },
                            text: "View Local Database",
                            icon: Icons.storage_rounded,
                          ),
                          buildActionButton(
                            onPressed: () async {
                              final all =
                                  await SongsDatabase.instance.readAllSongs();
                              final count = all.length;
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Local DB Records',
                                      style: GoogleFonts.jost()),
                                  content: Text('Total records: $count',
                                      style: GoogleFonts.jost()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Close',
                                          style: GoogleFonts.jost()),
                                    )
                                  ],
                                ),
                              );
                            },
                            text: 'Show Local DB Count',
                            icon: Icons.format_list_numbered_rounded,
                          ),
                          buildActionButton(
                            onPressed: () async {
                              await SongsDatabase.instance
                                  .deleteSongsDB("songs.db");
                              if (mounted) {
                                showRestartDialogBox(
                                  context,
                                  titleMsg: "Restart Required",
                                  descriptionMsg:
                                      "The database was deleted. Please restart the app to reflect changes.",
                                );
                              }
                            },
                            text: "Delete Local Database",
                            icon: Icons.delete_forever_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Configurations Section
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Configurations",
                            style: GoogleFonts.jost(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "No configurations available yet",
                              style: GoogleFonts.jost(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
