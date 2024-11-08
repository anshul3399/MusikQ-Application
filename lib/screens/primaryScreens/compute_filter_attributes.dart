import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_manager/screens/primaryScreens/app_access_key_error_widget.dart';
import 'package:music_manager/screens/primaryScreens/apply_filters.dart';
import 'package:music_manager/screens/primaryScreens/empty_database_error_widget.dart';
import 'package:music_manager/services/model/app_configuration.dart';
import 'package:music_manager/services/model/app_user.dart';
import 'package:music_manager/services/model/filter_chips.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/model/songs_database.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ComputeFilterAttributesFromLocalDB extends StatefulWidget {
  const ComputeFilterAttributesFromLocalDB({super.key});

  @override
  State<ComputeFilterAttributesFromLocalDB> createState() =>
      _FetchFilterAttributesState();
}

class _FetchFilterAttributesState
    extends State<ComputeFilterAttributesFromLocalDB> {
  // late Future<FilterChip_lists> _future;

  var chipLists = <String, List<FilterChipData>>{};
  late List<FilterChipData> yearChipsList;
  late List<FilterChipData> singerChipsList;
  late List<FilterChipData> musicDirectorChipsList;
  late List<FilterChipData> lyricistChipsList;
  late List<FilterChipData> artistsChipsList;
  late List<FilterChipData> primarySearchLabelsChipsList;
  late List<FilterChipData> secondarySearchLabelsChipsList;
  late List<FilterChipData> resourceTypeChipsList;
  late List<FilterChipData> likebilityIndexChipsList;

  getAllFilterChipLists() async {
    List distinctYearList =
        await SongsDatabase.instance.queryForDistinctYears();
    yearChipsList = await generateChips(distinctYearList);

    List distinctSingerList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues('Singers');
    singerChipsList = await generateChips(distinctSingerList);

    List distinctMusicDirectorList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues('Music_Director');
    musicDirectorChipsList = await generateChips(distinctMusicDirectorList);

    List distinctLyricistList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues('Lyricist');
    lyricistChipsList = await generateChips(distinctLyricistList);

    List distinctArtistsList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues('Artists');
    artistsChipsList = await generateChips(distinctArtistsList);

    List distinctPrimarySearchLabelsList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues('Primary_Search_Labels');
    primarySearchLabelsChipsList =
        await generateChips(distinctPrimarySearchLabelsList);

    List distinctSecondarySearchLabelsList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues('Secondary_Search_Labels');
    secondarySearchLabelsChipsList =
        await generateChips(distinctSecondarySearchLabelsList);

    List distinctResourceTypeList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues(SongsDBFields.resourceType);
    resourceTypeChipsList = await generateChips(distinctResourceTypeList);

    List distinctlikebilityIndexList = await SongsDatabase.instance
        .queryForDistinctConsolidatedvalues(SongsDBFields.likebilityIndex);
    likebilityIndexChipsList = await generateChips(distinctlikebilityIndexList);

    chipLists["yearChipsList"] = yearChipsList;
    chipLists["singerChipsList"] = singerChipsList;
    chipLists["musicDirectorChipsList"] = musicDirectorChipsList;
    chipLists["lyricistChipsList"] = lyricistChipsList;
    chipLists["artistsChipsList"] = artistsChipsList;
    chipLists["primarySearchLabelsChipsList"] = primarySearchLabelsChipsList;
    chipLists["secondarySearchLabelsChipsList"] =
        secondarySearchLabelsChipsList;
    chipLists["resourceTypeChipsList"] = resourceTypeChipsList;
    chipLists["likebilityIndexChipsList"] = likebilityIndexChipsList;
    return chipLists;
  }

  @override
  Widget build(BuildContext context) {
    final appConfigData = Provider.of<AppConfiguration>(context);
    final userData = Provider.of<UserData>(context);
    return (appConfigData.appAccessKey != userData.appAccessKey)
        ?
        // The appAccessKey parameter of Application and User doesn't match
        AccessKeyMismatchError()
        : (appConfigData.deleteDB || userData.remotelyDeleteDB)
            ?
            // if the parameter 'deleteDB' in the Firestore document 'AppData' is set to true
            // or if if the parameter 'remotelyDeleteDB' in the Firestore collection 'userData' of the user is set to true
            // which means remote deletion of local database is enabled
            // therefore empty database error should be shown,
            // otherwise query to database should be made to create filter chips

            EmptyDatabaseError(
                msg: (appConfigData.deleteDB)
                    ? "Could not query DB, Remote Database Deletion Enabled"
                    : "Could not query DB, Remote Database Deletion for this user is Enabled",
              )
            :
            // the parameter 'deleteDB' in Firestore is set as false thus
            // querying to database to generate Filter Chip Data
            FutureBuilder(
                future: getAllFilterChipLists(),
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
                      var chipList =
                          snapshot.data! as Map<String, List<FilterChipData>>;
                      // chipList = chipList as Map<String, List<FilterChipData>>;
                      debugPrint(">>> CHIP LIST: ${chipList['yearChip_list']}");

                      return ApplyFilters(
                        yearChips: chipList['yearChipsList']!,
                        singerChips: chipList['singerChipsList']!,
                        musicDirectorChips: chipList['musicDirectorChipsList']!,
                        lyricistChips: chipList['lyricistChipsList']!,
                        artistsChips: chipList['artistsChipsList']!,
                        primarySearchLabelsChips:
                            chipLists["primarySearchLabelsChipsList"]!,
                        secondarySearchLabelsChips:
                            chipLists["secondarySearchLabelsChipsList"]!,
                        resourceTypeChips: chipLists["resourceTypeChipsList"]!,
                        likebilityIndexChips:
                            chipLists["likebilityIndexChipsList"]!,
                      );
                    }
                  }

                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: SpinKitChasingDots(
                      color: Color.fromARGB(255, 227, 223, 223),
                      size: 40.0,
                    ),
                  );
                },
              );
  }
}
