import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/screens/primaryScreens/app_access_key_error_widget.dart';
import 'package:music_manager/screens/primaryScreens/empty_database_error_widget.dart';
import 'package:music_manager/services/model/app_configuration.dart';
import 'package:music_manager/services/model/app_user.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/model/songs_database.dart';
import 'package:music_manager/shared/searchBox_widget.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongsListView extends StatefulWidget {
  const SongsListView({super.key});

  @override
  State<SongsListView> createState() => _SongsListViewState();
}

class _SongsListViewState extends State<SongsListView> {
  late List<SongData> allSongs = [];
  late List<SongData> filteredSongs = [];
  String searchquery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      allSongs = await SongsDatabase.instance.readAllSongs() as List<SongData>;
      setState(() {
        filteredSongs = allSongs;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error loading songs: $error");
    }
  }

  void searchSongs(String query) {
    final queryLower = query.toLowerCase();

    final songs = allSongs.where((song) {
      return (song.songTitle!.toLowerCase().contains(queryLower) ||
              song.primarySearchLabels!.toLowerCase().contains(queryLower) ||
              song.secondarySearchLabels!.toLowerCase().contains(queryLower) ||
              song.year!.toLowerCase().contains(queryLower)) ||
          song.albumOrSingle!.toLowerCase().contains(queryLower);
    }).toList();

    setState(() {
      searchquery = query;
      filteredSongs = songs;
    });
  }

  Future<void> _launchInApp(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appConfigData = Provider.of<AppConfiguration>(context);
    final userData = Provider.of<UserData>(context);

    // if the parameter 'deleteDB' in the Firestore document 'AppData' is set to true
    // or if if the parameter 'remotelyDeleteDB' in the Firestore collection 'userData' of the user is set to true
    // which means remote deletion of local database is enabled
    // therefore empty database error should be shown,
    // otherwise query to database should be made to create filter chips
    if (appConfigData.appAccessKey != userData.appAccessKey) {
      return AccessKeyMismatchError();
    } else if (appConfigData.deleteDB || userData.remotelyDeleteDB) {
      return EmptyDatabaseError(
        msg: appConfigData.deleteDB
            ? "Could not query DB, Remote Database Deletion Enabled"
            : "Could not query DB, Remote Database Deletion for this user is Enabled",
      );
    }
// the parameter 'deleteDB' in Firestore is set as false thus population the data
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  "Songs",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SearchWidget(
                  text: searchquery,
                  hintText: 'Search',
                  onChanged: searchSongs,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 3),
          isLoading
              ? const Center(
                  child: SpinKitChasingDots(
                    color: Color.fromARGB(255, 158, 151, 151),
                    size: 30.0,
                  ),
                )
              : filteredSongs.isEmpty
                  ? EmptyDatabaseError(
                      msg:
                          "Nothing here, Try fetching data from remote DB to local first.")
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredSongs.length,
                        itemBuilder: (context, index) {
                          final song = filteredSongs[index];
                          return ListTile(
                            leading: SizedBox(
                              height: 60.0,
                              width: 60.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: song.thumbnailURL!,
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline_outlined,
                                    color: Color.fromARGB(255, 172, 172, 171),
                                  ),
                                  placeholder: (context, url) =>
                                      const SpinKitChasingDots(
                                    color: Color.fromARGB(255, 172, 172, 171),
                                    size: 15.0,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              song.songTitle!,
                              style: GoogleFonts.josefinSans(
                                  fontSize: 16,
                                  color:
                                      const Color.fromARGB(255, 225, 225, 225)),
                            ),
                            subtitle: Text(
                              song.year ?? '',
                              style: GoogleFonts.josefinSans(
                                  fontSize: 12,
                                  color:
                                      const Color.fromARGB(255, 189, 189, 189)),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                song.resourceURL!.contains('search?q=')
                                    ? Icons.search_rounded
                                    : Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                              onPressed: () {
                                final resourceURL =
                                    Uri.parse(song.resourceURL!);
                                debugPrint(">>> URL: $resourceURL");
                                _launchInApp(resourceURL);
                              },
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
