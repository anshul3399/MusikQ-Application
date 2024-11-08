// Result page of query.
// The entities matching with applied filters are shown in this view
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class FilteredResultListView extends StatefulWidget {
  List<SongData> filteredResultList;

  FilteredResultListView({super.key, required this.filteredResultList});

  @override
  State<FilteredResultListView> createState() => _FilteredResultListViewState();
}

class _FilteredResultListViewState extends State<FilteredResultListView> {
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
    List<SongData> data = widget.filteredResultList;
    return Material(
      color: Colors.black,
      child: Container(
        //TODO: to change this Top parameter in Edge Insets, initially it was 80 (imitating space left for appbar)
        padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
        decoration: CustomBackgroundGradientStyles.applicationBackground(
            context.read<GradientBackgroundTheme>().bgThemeType),
        child: (data.isEmpty)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/illustrations/not_found_any_match_query_1.svg',
                      width: 150.0,
                      height: 150.0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Nothing matches with you applied filter :)",
                      style: GoogleFonts.josefinSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      "Query Results",
                      style: GoogleFonts.merienda(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Expanded(
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
                          //TODO: Automatic left sliding text if the name of title is big
                          title: Text(
                            data[index].songTitle!,
                            style: GoogleFonts.josefinSans(
                                fontSize: 16,
                                color: Color.fromARGB(255, 225, 225, 225)),
                          ),
                          subtitle: Text(
                            data[index].year ?? '',
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
                                  (data[index]
                                          .resourceURL!
                                          .contains('search?q='))
                                      ? Icons.search_rounded
                                      : Icons.arrow_forward_ios_rounded,
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
                          // TODO : To remove this on tap url opening, on tapping the song details/data should be shown and the right arrow should lead to opening url in app
                          onTap: () {
                            final resourceURL =
                                Uri.parse(data[index].resourceURL!);
                            debugPrint(">>> URL: $resourceURL");
                            _launchInApp(resourceURL);
                          },
                        );
                      },
                      itemCount: data.length,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
