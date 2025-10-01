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
  Future<List<SongData>?> getAllSongsRecords() async {
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FutureBuilder<List<SongData>?>(
        future: getAllSongsRecords(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitChasingDots(
                color: Color.fromARGB(255, 158, 151, 151),
                size: 50.0,
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }

          // No data or empty
          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return Center(
              child: Text(
                'No online data available.',
                style: GoogleFonts.jost(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            );
          }

          // Data available
          return Container(
            alignment: Alignment.topLeft,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                final song = data[index];

                Widget leadingImage;
                final thumb = song.thumbnailURL;
                if (thumb == null || thumb.trim().isEmpty) {
                  leadingImage = Container(
                    color: const Color.fromARGB(40, 255, 255, 255),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Color.fromARGB(200, 200, 200, 200),
                    ),
                  );
                } else {
                  leadingImage = CachedNetworkImage(
                    imageUrl: thumb,
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image_outlined,
                      color: Color.fromARGB(255, 172, 172, 171),
                    ),
                    placeholder: (context, url) => const Center(
                      child: SpinKitChasingDots(
                        color: Color.fromARGB(255, 172, 172, 171),
                        size: 15.0,
                      ),
                    ),
                  );
                }

                return ListTile(
                  leading: SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: leadingImage,
                    ),
                  ),
                  title: Text(
                    song.songTitle ?? 'Untitled',
                    style: GoogleFonts.josefinSans(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 225, 225, 225)),
                  ),
                  subtitle: Text(
                    song.year ?? '',
                    style: GoogleFonts.josefinSans(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 189, 189, 189)),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () {
                          final resource = song.resourceURL;
                          if (resource == null || resource.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No resource URL available for this item.',
                                  style: GoogleFonts.jost(),
                                ),
                              ),
                            );
                            return;
                          }

                          final resourceURL = Uri.tryParse(resource);
                          if (resourceURL == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Invalid resource URL.',
                                  style: GoogleFonts.jost(),
                                ),
                              ),
                            );
                            return;
                          }

                          debugPrint('>>> URL: $resourceURL');
                          _launchInApp(resourceURL);
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    final resource = song.resourceURL;
                    if (resource == null || resource.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'No resource URL available for this item.',
                            style: GoogleFonts.jost(),
                          ),
                        ),
                      );
                      return;
                    }

                    final resourceURL = Uri.tryParse(resource);
                    if (resourceURL == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Invalid resource URL.',
                            style: GoogleFonts.jost(),
                          ),
                        ),
                      );
                      return;
                    }

                    debugPrint('>>> URL: $resourceURL');
                    _launchInApp(resourceURL);
                  },
                );
              },
              itemCount: data.length,
            ),
          );
        },
      ),
    );
  }
}
