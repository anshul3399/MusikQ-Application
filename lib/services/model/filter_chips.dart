// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:music_manager/services/model/songs_database.dart';

class FilterChips {
  List distinctYears = [];
  getDataForChips(List distinctYears) async {
    distinctYears = await SongsDatabase.instance.queryForDistinctYears();
  }

  // Future<List<FilterChipData>> getYears_testingFunct() async {
  //   Future.delayed(Duration(seconds: 2));
  //   List distinctYears = await SongsDatabase.instance.queryForDistinctYears();
  //   Future<List<FilterChipData>> singerChips = generateChips(distinctYears);
  //   return singerChips;
  // }

  static List<FilterChipData> yearChips =
      generateStaticChips([2003, 2012, 2016, 2020, 2018, 2015, 2009]);

  static List<FilterChipData> singersChips = generateStaticChips([
    'Arijit Singh',
    'Mohit Chauhan',
    'KK',
    'Javed Ali',
    'Shreya Ghoshal',
    'Sunidhi Chauhan'
  ]);
}

List<FilterChipData> generateStaticChips(List itemList) {
  return itemList
      .map((year) => FilterChipData(
            label: year.toString(),
            isSelected: false,
            unselectedTextColor: Color.fromARGB(255, 255, 255, 255),
          ))
      .toList();
}

//------------------------------START------------------------------
// The Below two functions were implemented to test the functionality of chip building from database data
// Future<List<FilterChipData>> getTempYears_testingFunct() async {
//   debugPrint(">> Delay start");
//   await Future.delayed(Duration(seconds: 2));
//   debugPrint(">> Delay end");
//   List distinctYears = await SongsDatabase.instance.queryForDistinctYears();
//   Future<List<FilterChipData>> singerChips = generateChips(distinctYears);
//   return singerChips;
// }

Future<List<FilterChipData>> generateChips(List yearList) async {
  return yearList
      .map((year) => FilterChipData(
            label: year.toString(),
            isSelected: false,
            unselectedTextColor: Color.fromARGB(255, 255, 255, 255),
          ))
      .toList();
}
//------------------------------END------------------------------

class FilterChipData {
  final String label;
  final Color unselectedTextColor;
  final bool isSelected;

  const FilterChipData({
    required this.label,
    required this.unselectedTextColor,
    this.isSelected = false,
  });

  FilterChipData copy({
    String? label,
    Color? unselectedTextColor,
    bool? isSelected,
  }) =>
      FilterChipData(
        label: label ?? this.label,
        unselectedTextColor: unselectedTextColor ?? this.unselectedTextColor,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterChipData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          unselectedTextColor == other.unselectedTextColor &&
          isSelected == other.isSelected;

  @override
  int get hashCode =>
      label.hashCode ^ unselectedTextColor.hashCode ^ isSelected.hashCode;
}
