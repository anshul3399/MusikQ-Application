// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

String addQueryStringFor_IN_operator(String columnName,
    List<String> selectedYearlist, String currentQueryString) {
  String toReturnYearString = "";
  if (selectedYearlist.isEmpty) {
    toReturnYearString = "";
  } else {
    for (int i = 0; i < selectedYearlist.length; i++) {
      if (i == selectedYearlist.length - 1) {
        toReturnYearString += "'${selectedYearlist[i]}'";
      } else {
        toReturnYearString += "'${selectedYearlist[i]}',";
      }
    }
    toReturnYearString = "($columnName IN ($toReturnYearString))";
  }
  debugPrint(">>> To return $columnName string: $toReturnYearString");
  if (currentQueryString
      .substring(currentQueryString.length - 6, currentQueryString.length)
      .contains("WHERE")) {
    currentQueryString += toReturnYearString;
  } else {
    if (toReturnYearString.isNotEmpty) {
      currentQueryString += " AND $toReturnYearString";
    }
  }
  return currentQueryString;
}

String addQueryStringFor_LIKE_operator(
    String columnName, List selectedItemsList, String currentQueryString) {
  String toReturnSectionQueryString = "";
  if (selectedItemsList.isEmpty) {
    toReturnSectionQueryString = "";
  } else {
    for (int i = 0; i < selectedItemsList.length; i++) {
      if (i == selectedItemsList.length - 1) {
        toReturnSectionQueryString +=
            "$columnName LIKE '%${selectedItemsList[i]}%'";
      } else {
        toReturnSectionQueryString +=
            "$columnName LIKE '%${selectedItemsList[i]}%' OR ";
      }
    }
    toReturnSectionQueryString = "($toReturnSectionQueryString)";
  }
  debugPrint(">>> To return $columnName string: $toReturnSectionQueryString");
  if (currentQueryString
      .substring(currentQueryString.length - 6, currentQueryString.length)
      .contains("WHERE")) {
    currentQueryString += toReturnSectionQueryString;
  } else {
    if (toReturnSectionQueryString.isNotEmpty) {
      currentQueryString += " AND $toReturnSectionQueryString";
    }
  }
  return currentQueryString;
}
