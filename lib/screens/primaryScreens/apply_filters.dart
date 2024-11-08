import 'package:flutter/material.dart';
import 'package:music_manager/screens/primaryScreens/filtered_result_list.dart';
import 'package:music_manager/services/model/filter_chips.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/model/songs_database.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ApplyFilters extends StatefulWidget {
  List<FilterChipData> yearChips;
  List<FilterChipData> singerChips;
  List<FilterChipData> musicDirectorChips;
  List<FilterChipData> lyricistChips;
  List<FilterChipData> artistsChips;
  List<FilterChipData> primarySearchLabelsChips;
  List<FilterChipData> secondarySearchLabelsChips;
  List<FilterChipData> resourceTypeChips;
  List<FilterChipData> likebilityIndexChips;

  ApplyFilters(
      {super.key,
      required this.yearChips,
      required this.singerChips,
      required this.musicDirectorChips,
      required this.lyricistChips,
      required this.artistsChips,
      required this.primarySearchLabelsChips,
      required this.secondarySearchLabelsChips,
      required this.resourceTypeChips,
      required this.likebilityIndexChips});

  @override
  State<ApplyFilters> createState() => _ApplyFiltersState();
}

class _ApplyFiltersState extends State<ApplyFilters> {
  final double spacing = 8.0;

  // Primary Search Labels chip associated variables
  double primarySearchLabelsContainerHeight = 70;
  double primarySearchLabelsContainerWidth = 90;
  bool primarySearchLabelsContainerToggle = false;
  List<String> selectedPrimarySearchLabels = [];

  // Secondary Search Labels chip associated variables
  double secondarySearchLabelsContainerHeight = 70;
  double secondarySearchLabelsContainerWidth = 90;
  bool secondarySearchLabelsContainerToggle = false;
  List<String> selectedSecondarySearchLabels = [];

  // Likebility Index chip associated variables
  double likebilityIndexContainerHeight = 70;
  double likebilityIndexContainerWidth = 90;
  bool likebilityIndexContainerToggle = false;
  List<String> selectedLikebilityIndexes = [];

  // Year Filter chip associated variables
  double yearContainerHeight = 70;
  double yearContainerWidth = 90;
  bool yearContainerToggle = false;
  List<String> selectedYears = [];

  // Singers Filter chip associated variables
  double singerContainerHeight = 70;
  double singerContainerWidth = 90;
  bool singerContainerToggle = false;
  List<String> selectedSingers = [];

  // Music Directors chip associated variables
  double musicdirectorContainerHeight = 70;
  double musicdirectorContainerWidth = 90;
  bool musicdirectorContainerToggle = false;
  List<String> selectedMusicDirectors = [];

  // Lyricist chip associated variables
  double lyricistContainerHeight = 70;
  double lyricistContainerWidth = 90;
  bool lyricistContainerToggle = false;
  List<String> selectedLyricist = [];

  // Artists chip associated variables
  double artistsContainerHeight = 70;
  double artistsContainerWidth = 90;
  bool artistsContainerToggle = false;
  List<String> selectedArtists = [];

  // Resource Type chip associated variables
  double resourceTypeContainerHeight = 70;
  double resourceTypeContainerWidth = 90;
  bool resourceTypeContainerToggle = false;
  List<String> selectedResourceType = [];

  @override
  Widget build(BuildContext context) {
    callbackPrimarySearchLabelsUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.primarySearchLabelsChips = updatedList;
        selectedPrimarySearchLabels = selectedItems;
      });
    }

    callbackSecondarySearchLabelsUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.secondarySearchLabelsChips = updatedList;
        selectedSecondarySearchLabels = selectedItems;
      });
    }

    callbackLikebilityIndexesUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.likebilityIndexChips = updatedList;
        selectedLikebilityIndexes = selectedItems;
      });
    }

    callbackYearUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.yearChips = updatedList;
        selectedYears = selectedItems;
      });
    }

    // List<FilterChipData> singerFilterChip_list = widget.singerChips;
    callbackUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.singerChips = updatedList;
        selectedSingers = selectedItems;
      });
    }

    callbackMusicDirectorsUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.musicDirectorChips = updatedList;
        selectedMusicDirectors = selectedItems;
      });
    }

    callbackLyricistUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.lyricistChips = updatedList;
        selectedLyricist = selectedItems;
      });
    }

    callbackArtistsUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.artistsChips = updatedList;
        selectedArtists = selectedItems;
      });
    }

    callbackResourceTypeUpdatedFilterChipList(
        List<FilterChipData> updatedList, List<String> selectedItems) {
      setState(() {
        widget.resourceTypeChips = updatedList;
        selectedResourceType = selectedItems;
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05, 80, 0, 0),
        decoration: CustomBackgroundGradientStyles.applicationBackground(
            context.read<GradientBackgroundTheme>().bgThemeType),
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primary Search Labels Filter Components
              // Primary Search Labels Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    primarySearchLabelsContainerToggle =
                        !primarySearchLabelsContainerToggle;
                    primarySearchLabelsContainerHeight =
                        (primarySearchLabelsContainerToggle == false)
                            ? 70
                            : 250;
                    primarySearchLabelsContainerWidth =
                        (primarySearchLabelsContainerToggle == false)
                            ? 90
                            : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Primary Search Labels",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Primary Search Labels-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: primarySearchLabelsContainerHeight,
                width: primarySearchLabelsContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(
                      widget.primarySearchLabelsChips,
                      selectedPrimarySearchLabels,
                      callbackPrimarySearchLabelsUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Secondary Search Labels Filter Components
              // Secondary Search Labels Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    secondarySearchLabelsContainerToggle =
                        !secondarySearchLabelsContainerToggle;
                    secondarySearchLabelsContainerHeight =
                        (secondarySearchLabelsContainerToggle == false)
                            ? 70
                            : 250;
                    secondarySearchLabelsContainerWidth =
                        (secondarySearchLabelsContainerToggle == false)
                            ? 90
                            : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Secondary Search Labels",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Secondary Search Labels-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: secondarySearchLabelsContainerHeight,
                width: secondarySearchLabelsContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(
                      widget.secondarySearchLabelsChips,
                      selectedSecondarySearchLabels,
                      callbackSecondarySearchLabelsUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Likebility Index Filter Components
              // Likebility Index Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    likebilityIndexContainerToggle =
                        !likebilityIndexContainerToggle;
                    likebilityIndexContainerHeight =
                        (likebilityIndexContainerToggle == false) ? 70 : 250;
                    likebilityIndexContainerWidth =
                        (likebilityIndexContainerToggle == false)
                            ? 90
                            : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Likebility Index",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Likebility Index-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: likebilityIndexContainerHeight,
                width: likebilityIndexContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(
                      widget.likebilityIndexChips,
                      selectedLikebilityIndexes,
                      callbackLikebilityIndexesUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Year Filter Components
              // Year Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    yearContainerToggle = !yearContainerToggle;
                    yearContainerHeight =
                        (yearContainerToggle == false) ? 70 : 170;
                    yearContainerWidth = (yearContainerToggle == false)
                        ? 90
                        : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Year",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Year-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: yearContainerHeight,
                width: yearContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(widget.yearChips, selectedYears,
                      callbackYearUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Singers Filter Components
              // Singers Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    singerContainerToggle = !singerContainerToggle;
                    singerContainerHeight =
                        (singerContainerToggle == false) ? 70 : 250;
                    singerContainerWidth = (singerContainerToggle == false)
                        ? 90
                        : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Singers",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Singers-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: singerContainerHeight,
                width: singerContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(widget.singerChips, selectedSingers,
                      callbackUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Music Director Filter Components
              // Music Director Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    musicdirectorContainerToggle =
                        !musicdirectorContainerToggle;
                    musicdirectorContainerHeight =
                        (musicdirectorContainerToggle == false) ? 70 : 250;
                    musicdirectorContainerWidth =
                        (musicdirectorContainerToggle == false)
                            ? 90
                            : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Music Directors",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Music Director-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: musicdirectorContainerHeight,
                width: musicdirectorContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(
                      widget.musicDirectorChips,
                      selectedMusicDirectors,
                      callbackMusicDirectorsUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Lyricist Filter Components
              // Lyricist Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    lyricistContainerToggle = !lyricistContainerToggle;
                    lyricistContainerHeight =
                        (lyricistContainerToggle == false) ? 70 : 250;
                    lyricistContainerWidth = (lyricistContainerToggle == false)
                        ? 90
                        : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Lyricist",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Lyricist-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: lyricistContainerHeight,
                width: lyricistContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(widget.lyricistChips, selectedLyricist,
                      callbackLyricistUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Artists Filter Components
              // Artists Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    artistsContainerToggle = !artistsContainerToggle;
                    artistsContainerHeight =
                        (artistsContainerToggle == false) ? 70 : 250;
                    artistsContainerWidth = (artistsContainerToggle == false)
                        ? 90
                        : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Artists",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Artists-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: artistsContainerHeight,
                width: artistsContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(widget.artistsChips, selectedArtists,
                      callbackArtistsUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Resource Type Filter Components
              // Resource Type Text-Tappable
              GestureDetector(
                onTap: () {
                  setState(() {
                    resourceTypeContainerToggle = !resourceTypeContainerToggle;
                    resourceTypeContainerHeight =
                        (resourceTypeContainerToggle == false) ? 70 : 250;
                    resourceTypeContainerWidth =
                        (resourceTypeContainerToggle == false)
                            ? 90
                            : MediaQuery.of(context).size.width * 0.9;
                  });
                },
                child: Text(
                  "Resource Type",
                  style: CustomTextStyles.headingsTextStyle,
                ),
              ),
              // Resource Type-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                decoration:
                    CustomBackgroundGradientStyles.filterChipsBackground,
                height: resourceTypeContainerHeight,
                width: resourceTypeContainerWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: buildChips(
                      widget.resourceTypeChips,
                      selectedResourceType,
                      callbackResourceTypeUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      // Fire query on Local Database Songs DB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Map<String, List<String>> selectedItemsMap = {};
          // When a new column is added into database for query, update the below details.
          // NOTE: the key specified into the map below should be exact the column name as in the database
          // ex below, the 'Year' is the column name in the database specifying the year of the song.
          // Updated Map: {Year: [2012, 2014, 2016, 2020]}
          selectedItemsMap['Year'] = selectedYears;
          selectedItemsMap['Singers'] = selectedSingers;
          selectedItemsMap['Music_Director'] = selectedMusicDirectors;
          selectedItemsMap['Lyricist'] = selectedLyricist;
          selectedItemsMap['Artists'] = selectedArtists;
          selectedItemsMap['Primary_Search_Labels'] =
              selectedPrimarySearchLabels;
          selectedItemsMap['Secondary_Search_Labels'] =
              selectedSecondarySearchLabels;
          selectedItemsMap[SongsDBFields.resourceType] = selectedResourceType;
          selectedItemsMap[SongsDBFields.likebilityIndex] =
              selectedLikebilityIndexes;

          List<SongData> filteredResultList =
              await SongsDatabase.instance.queryDatabase(
            selectedItemsMap: selectedItemsMap,
          );
          filteredResultList.shuffle();
          if (mounted) {
            _navigateToNextScreen(context, filteredResultList);
          }
        },
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        foregroundColor: Colors.black,
        icon: Icon(
          Icons.manage_search_rounded,
          size: 27,
        ),
        label: Text('Query',
            style: GoogleFonts.jost(fontWeight: FontWeight.w500, fontSize: 15)),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context, List<SongData> list) {
    Navigator.of(context).push(PageTransition(
      type: PageTransitionType.scale,
      alignment: Alignment.bottomCenter,
      duration: Duration(milliseconds: 850),
      reverseDuration: Duration(milliseconds: 500),
      child: FilteredResultListView(
        filteredResultList: list,
      ),
    ));
  }

  // Build Chips inside Animated Container
  Widget buildChips(List<FilterChipData> filterChipList, List selectedItemsList,
      Function callbackUpdatedFilterChipList) {
    return Wrap(
      runSpacing: -5,
      spacing: 7,
      children: filterChipList.map((filterChip) {
        return FilterChip(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
          label: Text(filterChip.label),
          labelStyle: GoogleFonts.cabin(
              color: (filterChip.isSelected == false)
                  ? filterChip.unselectedTextColor
                  : Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 13),
          shape: StadiumBorder(
              side: BorderSide(
            // color: Colors.transparent,
            width: 0.3,
            color: (filterChip.isSelected == false)
                ? Colors.white
                : Colors.transparent,
          )),
          // chip background color
          backgroundColor: Color.fromARGB(204, 17, 17, 17),
          selectedColor: Colors.white,

          onSelected: (isSelected) {
            return setState(() {
              filterChipList = filterChipList.map((otherChip) {
                // debugPrint(
                //     ">> Singers filtered chp: <${filterChip.label}:${filterChip.isSelected}>\n\t Singers other chp: <${otherChip.label}:${otherChip.isSelected}>");
                if (filterChip == otherChip) {
                  // NOTE: adding and removal into list is done through juggad, trace variable values to know more
                  if (filterChip.isSelected == true) {
                    //remove item from list
                    selectedItemsList.remove(filterChip.label);
                  } else {
                    selectedItemsList.add(filterChip.label);
                  }

                  debugPrint(">> SELECTED ITEMS LIST = $selectedItemsList");
                  return otherChip.copy(
                      isSelected: isSelected,
                      label: filterChip.label,
                      unselectedTextColor: filterChip.unselectedTextColor);
                } else {
                  return otherChip;
                }
              }).toList();

              callbackUpdatedFilterChipList(filterChipList, selectedItemsList);
              // debugdebugPrint(">>> INSIDE set state -> Singers filter chip list : ");
              // for (int i = 0; i < filterChipList.length; i++) {
              //   debugPrint(
              //       ">> <${filterChipList[i].label}:${filterChipList[i].isSelected}>\n");
              // }
            });
          },
          selected: filterChip.isSelected,
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}
