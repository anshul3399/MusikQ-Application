import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/config/credentials.dart';

class SheetsApi {
  static const _credentials = GoogleSheetsCredentials.credentials;
  static const _spreadsheetId = GoogleSheetsCredentials.spreadsheetId;
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _songsSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      debugPrint(">>> Sheet Name: $spreadsheet");
      _songsSheet = await _getWorkSheet(spreadsheet, title: "Songs_DB");

      final headerRow = SongsDBFields.getFields();
      _songsSheet!.values.insertRow(1, headerRow);
    } catch (e) {
      debugPrint('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<SongData?> getByID(String id) async {
    if (_songsSheet == null) return null;

    final json = await _songsSheet!.values.map.rowByKey(id, fromColumn: 1);

    return (json == null) ? null : SongData.fromJson(json);
  }

  static Future<List<SongData>?> getAllRows() async {
    if (_songsSheet == null) return null;

    final response = await _songsSheet!.values.map.allRows();

    // debugdebugPrint(">> All row response: $response");

    if (response == null) {
      return null;
    } else {
      return List.from(
          response.map((item) => SongData.fromJson(item)).toList());
    }
  }
}
