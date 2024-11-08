// ****** CURRENTLY NOT BEING USED IN APPLICATION VIEW ******
// Fetch Data directly from online database (currently not in application view)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/sheets%20api/sheets_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class FetchSongsListView extends StatefulWidget {
  const FetchSongsListView({super.key});

  @override
  State<FetchSongsListView> createState() => _SongsListViewState();
}

class _SongsListViewState extends State<FetchSongsListView> {
  late Future<List?> songsDB;
  Future<List?> getAllSongsRecords() async {
    await SheetsApi.init();
    final songsDB = await SheetsApi.getAllRows();
    return songsDB;
  }

  Future<void> _launchInApp(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FutureBuilder(
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
              List<SongData> data = snapshot.data! as List<SongData>;
              return Container(
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                        height: 60.0,
                        width: 60.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: data[index].thumbnailURL!,
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline_outlined,
                              color: Color.fromARGB(255, 172, 172, 171),
                            ),
                            placeholder: (context, url) => Center(
                              child: SpinKitChasingDots(
                                color: Color.fromARGB(255, 172, 172, 171),
                                size: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        data[index].songTitle!,
                        style: GoogleFonts.josefinSans(
                            fontSize: 16,
                            color: Color.fromARGB(255, 225, 225, 225)),
                      ),
                      subtitle: Text(
                        data[index].year!,
                        style: GoogleFonts.josefinSans(
                            fontSize: 12,
                            color: Color.fromARGB(255, 189, 189, 189)),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            onPressed: () {
                              final resourceURL =
                                  Uri.parse(data[index].resourceURL!);
                              debugPrint(">>> URL: $resourceURL");
                              _launchInApp(resourceURL);
                            },
                          ),
                        ),
                      ),
                      onTap: () {
                        final resourceURL = Uri.parse(data[index].resourceURL!);
                        debugPrint(">>> URL: $resourceURL");
                        _launchInApp(resourceURL);
                      },
                    );
                  },
                  itemCount: data.length,
                ),
              );
            }
          }

          // Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: SpinKitChasingDots(
              color: Color.fromARGB(255, 158, 151, 151),
              size: 50.0,
            ),
          );
        },

        // Future that needs to be resolved
        // inorder to display something on the Canvas
        future: getAllSongsRecords(),
      ),
    );
  }
}
