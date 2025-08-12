import 'package:flutter/material.dart';
import 'package:music_manager/screens/primaryScreens/filtered_result_list.dart';
import 'package:music_manager/screens/primaryScreens/search_overlay.dart';
import 'package:music_manager/services/model/filter_chips.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/model/songs_database.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
  // From and To year text box field variables
  final TextEditingController fromYearController = TextEditingController();
  final TextEditingController toYearController = TextEditingController();

  Widget _buildFilterHeader(String title, bool hasSelected,
      VoidCallback onClear, VoidCallback onSearch, VoidCallback onTitleTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTitleTap,
            child: Text(
              title,
              style: CustomTextStyles.headingsTextStyle,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white70),
              onPressed: onSearch,
            ),
            IconButton(
              icon: Icon(Icons.clear_all_rounded,
                  color: hasSelected ? Colors.white : Colors.white24),
              onPressed: hasSelected ? onClear : null,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    fromYearController.dispose();
    toYearController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchOverlay(
      BuildContext context,
      String title,
      List<FilterChipData> chips,
      List<String> selectedItems,
      void Function(List<FilterChipData>, List<String>) callback) {
    _searchController.clear();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => SearchOverlay(
        title: title,
        chips: chips,
        selectedItems: selectedItems,
        onUpdate: (chips, items) {
          setState(() {
            callback(chips, items);
          });
        },
        searchController: _searchController,
        onSearchChanged:
            (_) {}, // We don't need this anymore as search is handled in SearchOverlay
        searchQuery: '', // Initial empty query
      ),
    );
  }

  void updateYearsRange() {
    final fromYear = int.tryParse(fromYearController.text);
    final toYear = int.tryParse(toYearController.text);

    if (fromYear != null &&
        toYear != null &&
        fromYear <= toYear &&
        fromYear >= 1900 &&
        toYear >= 1900 &&
        fromYear <= 2150 &&
        toYear <= 2150) {
      setState(() {
        selectedYears.clear();
        for (int year = fromYear; year <= toYear; year++) {
          selectedYears.add(year.toString());
        }
        debugPrint("Selected Years = $selectedYears");
      });

      widget.yearChips = widget.yearChips.map((chip) {
        return chip.copy(isSelected: false);
      }).toList();

      ScaffoldMessenger.of(context).showSnackBar(createCustomSnackBar(
          'Year filter applied, years from ${fromYear} to ${toYear}'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(createCustomSnackBar(
          'Invalid year range!\nEnter year range between 1900 - 2150.'));
    }
  }

  void resetYearsSelection() {
    setState(() {
      selectedYears.clear();
      fromYearController.clear();
      toYearController.clear();
    });

    widget.yearChips = widget.yearChips.map((chip) {
      return chip.copy(isSelected: false);
    }).toList();

    ScaffoldMessenger.of(context)
        .showSnackBar(createCustomSnackBar('Year filter resetted'));
  }

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

  // Clear Chips Functions
  // Primary Search Labels, Clear chips
  void resetPrimarySearchLabelsChips() {
    setState(() {
      selectedPrimarySearchLabels.clear();
      // Deselect all primary search label chips
      widget.primarySearchLabelsChips = widget.primarySearchLabelsChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Primary Search Labels chips cleared'),
    );
  }

  // Secondary Search Labels, Clear chips
  void resetSecondarySearchLabelsChips() {
    setState(() {
      selectedSecondarySearchLabels.clear();
      // Deselect all primary search label chips
      widget.secondarySearchLabelsChips = widget.secondarySearchLabelsChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Secondary Search Labels chips cleared'),
    );
  }

  // Likebility Index, Clear chips
  void resetLikebilityIndexChips() {
    setState(() {
      selectedLikebilityIndexes.clear();
      // Deselect all primary search label chips
      widget.likebilityIndexChips = widget.likebilityIndexChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Likebility Index chips cleared'),
    );
  }

  // Year, Clear chips
  void resetYearChips() {
    setState(() {
      selectedYears.clear();
      // Deselect all primary search label chips
      widget.yearChips =
          widget.yearChips.map((chip) => chip.copy(isSelected: false)).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Year chips cleared'),
    );
  }

  // Singers, Clear chips
  void resetSingersChips() {
    setState(() {
      selectedSingers.clear();
      // Deselect all primary search label chips
      widget.singerChips = widget.singerChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Singers chips cleared'),
    );
  }

  // Music Direcotrs, Clear chips
  void resetMusicDirectorsChips() {
    setState(() {
      selectedMusicDirectors.clear();
      // Deselect all primary search label chips
      widget.musicDirectorChips = widget.musicDirectorChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Music Directors chips cleared'),
    );
  }

  // Lyricist, Clear chips
  void resetLyricistChips() {
    setState(() {
      selectedLyricist.clear();
      // Deselect all primary search label chips
      widget.lyricistChips = widget.lyricistChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Lyricist chips cleared'),
    );
  }

  // Artists, Clear chips
  void resetArtistsChips() {
    setState(() {
      selectedArtists.clear();
      // Deselect all primary search label chips
      widget.artistsChips = widget.artistsChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Artists chips cleared'),
    );
  }

  // Resource Type, Clear chips
  void resetResourceTypeChips() {
    setState(() {
      selectedResourceType.clear();
      // Deselect all primary search label chips
      widget.resourceTypeChips = widget.resourceTypeChips
          .map((chip) => chip.copy(isSelected: false))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      createCustomSnackBar('Resource Type chips cleared'),
    );
  }

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

    void callbackYearUpdatedFilterChipList(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primary Search Labels Filter Components
              // Primary Search Labels Text-Tappable
              _buildFilterHeader(
                'Primary Tags',
                selectedPrimarySearchLabels.isNotEmpty,
                resetPrimarySearchLabelsChips,
                () => _showSearchOverlay(
                  context,
                  'Primary Tags',
                  widget.primarySearchLabelsChips,
                  selectedPrimarySearchLabels,
                  callbackPrimarySearchLabelsUpdatedFilterChipList,
                ),
                () {
                  setState(() {
                    primarySearchLabelsContainerToggle =
                        !primarySearchLabelsContainerToggle;
                    primarySearchLabelsContainerHeight =
                        primarySearchLabelsContainerToggle
                            ? MediaQuery.of(context).size.height * 0.4
                            : 70;
                    primarySearchLabelsContainerWidth =
                        primarySearchLabelsContainerToggle
                            ? MediaQuery.of(context).size.width * 0.9
                            : 90;
                  });
                },
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
              _buildFilterHeader(
                'Secondary Tags',
                selectedSecondarySearchLabels.isNotEmpty,
                resetSecondarySearchLabelsChips,
                () => _showSearchOverlay(
                  context,
                  'Secondary Tags',
                  widget.secondarySearchLabelsChips,
                  selectedSecondarySearchLabels,
                  callbackSecondarySearchLabelsUpdatedFilterChipList,
                ),
                () {
                  setState(() {
                    secondarySearchLabelsContainerToggle =
                        !secondarySearchLabelsContainerToggle;
                    secondarySearchLabelsContainerHeight =
                        secondarySearchLabelsContainerToggle ? 250 : 70;
                    secondarySearchLabelsContainerWidth =
                        secondarySearchLabelsContainerToggle
                            ? MediaQuery.of(context).size.width * 0.9
                            : 90;
                  });
                },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        likebilityIndexContainerToggle =
                            !likebilityIndexContainerToggle;
                        likebilityIndexContainerHeight =
                            (likebilityIndexContainerToggle == false) ? 70 : 70;
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
                  IconButton(
                    icon: Icon(Icons.clear_all_rounded, color: Colors.white),
                    tooltip: 'Clear Likebility Index',
                    onPressed: selectedLikebilityIndexes.isNotEmpty
                        ? resetLikebilityIndexChips
                        : null, // Disable if nothing is selected
                  ),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        yearContainerToggle = !yearContainerToggle;
                        yearContainerHeight = yearContainerToggle ? 170 : 70;
                        yearContainerWidth = yearContainerToggle
                            ? MediaQuery.of(context).size.width * 0.9
                            : 90;
                      });
                    },
                    child: Text(
                      "Year",
                      style: CustomTextStyles.headingsTextStyle,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear_all_rounded, color: Colors.white),
                    tooltip: 'Clear Year',
                    onPressed: selectedYears.isNotEmpty
                        ? resetYearChips
                        : null, // Disable if nothing is selected
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // From Year and To Year Input Fields with Add and Reset Buttons
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: fromYearController,
                        cursorColor: Colors.white,
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          labelText: 'From Year',
                          labelStyle: GoogleFonts.jost(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(131, 134, 134, 134),
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(82, 106, 106, 106),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(225, 255, 255, 255),
                              )),
                        ),
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.jost(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: toYearController,
                        cursorColor: Colors.white,
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          labelText: 'To Year',
                          labelStyle: GoogleFonts.jost(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(131, 134, 134, 134),
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(82, 106, 106, 106),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(225, 255, 255, 255),
                              )),
                        ),
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.jost(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.playlist_add_check_rounded,
                          color: Colors.white),
                      onPressed: updateYearsRange,
                    ),
                    IconButton(
                      icon: Icon(Icons.clear_rounded, color: Colors.white),
                      onPressed: resetYearsSelection,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
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
                  child: buildChips(widget.yearChips, selectedYears,
                      callbackYearUpdatedFilterChipList),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              // Singers Filter Components
              // Singers Text-Tappable
              _buildFilterHeader(
                'Singers',
                selectedSingers.isNotEmpty,
                resetSingersChips,
                () => _showSearchOverlay(
                  context,
                  'Singers',
                  widget.singerChips,
                  selectedSingers,
                  callbackUpdatedFilterChipList,
                ),
                () {
                  setState(() {
                    singerContainerToggle = !singerContainerToggle;
                    singerContainerHeight = singerContainerToggle ? 250 : 70;
                    singerContainerWidth = singerContainerToggle
                        ? MediaQuery.of(context).size.width * 0.9
                        : 90;
                  });
                },
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
              _buildFilterHeader(
                'Music Directors',
                selectedMusicDirectors.isNotEmpty,
                resetMusicDirectorsChips,
                () => _showSearchOverlay(
                  context,
                  'Music Directors',
                  widget.musicDirectorChips,
                  selectedMusicDirectors,
                  callbackMusicDirectorsUpdatedFilterChipList,
                ),
                () {
                  setState(() {
                    musicdirectorContainerToggle =
                        !musicdirectorContainerToggle;
                    musicdirectorContainerHeight =
                        musicdirectorContainerToggle ? 250 : 70;
                    musicdirectorContainerWidth = musicdirectorContainerToggle
                        ? MediaQuery.of(context).size.width * 0.9
                        : 90;
                  });
                },
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
              _buildFilterHeader(
                'Lyricist',
                selectedLyricist.isNotEmpty,
                resetLyricistChips,
                () => _showSearchOverlay(
                  context,
                  'Lyricist',
                  widget.lyricistChips,
                  selectedLyricist,
                  callbackLyricistUpdatedFilterChipList,
                ),
                () {
                  setState(() {
                    lyricistContainerToggle = !lyricistContainerToggle;
                    lyricistContainerHeight =
                        lyricistContainerToggle ? 250 : 70;
                    lyricistContainerWidth = lyricistContainerToggle
                        ? MediaQuery.of(context).size.width * 0.9
                        : 90;
                  });
                },
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
              _buildFilterHeader(
                'Artists',
                selectedArtists.isNotEmpty,
                resetArtistsChips,
                () => _showSearchOverlay(
                  context,
                  'Artists',
                  widget.artistsChips,
                  selectedArtists,
                  callbackArtistsUpdatedFilterChipList,
                ),
                () {
                  setState(() {
                    artistsContainerToggle = !artistsContainerToggle;
                    artistsContainerHeight = artistsContainerToggle ? 250 : 70;
                    artistsContainerWidth = artistsContainerToggle
                        ? MediaQuery.of(context).size.width * 0.9
                        : 90;
                  });
                },
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
              _buildFilterHeader(
                'Resource Type',
                selectedResourceType.isNotEmpty,
                resetResourceTypeChips,
                () => _showSearchOverlay(
                  context,
                  'Resource Type',
                  widget.resourceTypeChips,
                  selectedResourceType,
                  callbackResourceTypeUpdatedFilterChipList,
                ),
                () {
                  setState(() {
                    resourceTypeContainerToggle = !resourceTypeContainerToggle;
                    resourceTypeContainerHeight = resourceTypeContainerToggle
                        ? 250
                        : 70; // Changed from 70 to 250
                    resourceTypeContainerWidth = resourceTypeContainerToggle
                        ? MediaQuery.of(context).size.width * 0.9
                        : 90;
                  });
                },
              ),
              // Resource Type-Chips Animated Container
              AnimatedContainer(
                duration: Duration(milliseconds: 1200),
                alignment: Alignment.topLeft,
                curve: Curves.easeInOutBack,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(
                    bottom: 20), // Added bottom margin for last item
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
              )
            ],
          ),
        ),
      ),
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
        icon: Icon(Icons.manage_search_rounded, size: 27),
        label: Text(
          'Query',
          style: GoogleFonts.jost(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context, List<SongData> list) {
    Navigator.of(context).push(PageTransition(
      type: PageTransitionType.scale,
      alignment: Alignment.bottomCenter,
      duration: Duration(milliseconds: 850),
      reverseDuration: Duration(milliseconds: 500),
      child: FilteredResultListView(filteredResultList: list),
    ));
  }

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
              color: filterChip.isSelected
                  ? Colors.black
                  : filterChip.unselectedTextColor,
              fontWeight: FontWeight.w400,
              fontSize: 13),
          shape: StadiumBorder(
              side: BorderSide(
            width: 0.3,
            color: filterChip.isSelected ? Colors.transparent : Colors.white,
          )),
          backgroundColor: Color.fromARGB(204, 17, 17, 17),
          selectedColor: Colors.white,
          onSelected: (isSelected) {
            setState(() {
              filterChipList = filterChipList.map((otherChip) {
                if (filterChip == otherChip) {
                  if (filterChip.isSelected) {
                    selectedItemsList.remove(filterChip.label);
                  } else {
                    selectedItemsList.add(filterChip.label);
                  }
                  return otherChip.copy(
                      isSelected: isSelected,
                      label: filterChip.label,
                      unselectedTextColor: filterChip.unselectedTextColor);
                }
                return otherChip;
              }).toList();

              callbackUpdatedFilterChipList(filterChipList, selectedItemsList);
            });
          },
          selected: filterChip.isSelected,
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}
