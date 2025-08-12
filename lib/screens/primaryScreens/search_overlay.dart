import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/services/model/filter_chips.dart';
import 'package:music_manager/shared/custom_chip.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:music_manager/shared/transparent_chip.dart';

class SearchOverlay extends StatefulWidget {
  final String title;
  final List<FilterChipData> chips;
  final List<String> selectedItems;
  final Function(List<FilterChipData>, List<String>) onUpdate;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const SearchOverlay({
    Key? key,
    required this.title,
    required this.chips,
    required this.selectedItems,
    required this.onUpdate,
    required this.searchController,
    required this.onSearchChanged,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  late List<String> _selectedItems;
  String _localSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedItems = List<String>.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    var filteredChips = widget.chips
        .where((chip) =>
            chip.label.toLowerCase().contains(_localSearchQuery.toLowerCase()))
        .toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        //color: Colors.black87, // Solid dark background to block underlying UI
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color.fromARGB(255, 75, 75, 75),
                  Color.fromARGB(255, 44, 44, 44),
                  Colors.black,
                ],
                stops: const [0.05, 0.2, 0.99],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          child: TextField(
                            controller: widget.searchController,
                            style: GoogleFonts.jost(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search ${widget.title}...',
                              hintStyle:
                                  GoogleFonts.jost(color: Colors.white70),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white70),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: Colors.black38,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white24),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _localSearchQuery = value;
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints:
                            BoxConstraints(minWidth: 40, minHeight: 40),
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: filteredChips.map((chip) {
                          bool isSelected = _selectedItems.contains(chip.label);
                          return CustomChip(
                            label: chip.label,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (!isSelected) {
                                  _selectedItems.add(chip.label);
                                } else {
                                  _selectedItems.remove(chip.label);
                                }
                                var updatedChips = widget.chips
                                    .map((c) => FilterChipData(
                                          label: c.label,
                                          isSelected:
                                              _selectedItems.contains(c.label),
                                          unselectedTextColor: Colors.white,
                                        ))
                                    .toList();
                                widget.onUpdate(updatedChips, _selectedItems);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
