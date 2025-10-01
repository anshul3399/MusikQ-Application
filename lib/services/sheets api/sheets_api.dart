import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/config/credentials.dart';

class SheetsApi {
  static const _credentials = GoogleSheetsCredentials.credentials;
  static const _spreadsheetId = GoogleSheetsCredentials.spreadsheetId;
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _songsSheet;
  // Debugging helpers
  static bool verbose = true; // toggle detailed logs
  static int initCallCount = 0;
  static int getAllRowsCallCount = 0;
  static DateTime? lastSuccessfulFetch;

  static Future init() async {
    initCallCount++;
    if (verbose)
      debugPrint(
          'SheetsApi.init called (${initCallCount}) at ${DateTime.now().toIso8601String()}');
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      debugPrint(">>> Sheet fetched (read-only): $_spreadsheetId");

      // Only locate the worksheet; do not create or write anything to avoid exhausting quota.
      Worksheet? sheet = spreadsheet.worksheetByTitle('Songs_DB');
      if (sheet == null) {
        debugPrint(
            'SheetsApi.init: worksheet Songs_DB not found (read-only mode).');
        _songsSheet = null;
      } else {
        _songsSheet = sheet;
        debugPrint('SheetsApi.init: worksheet Songs_DB located.');
      }
    } on GSheetsException catch (e, st) {
      debugPrint('Init Error (GSheetsException): $e');
      debugPrint(st.toString());
      _songsSheet = null;
    } catch (e, st) {
      debugPrint('Init Error: $e');
      debugPrint(st.toString());
      _songsSheet = null;
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    // Prefer finding the existing worksheet before attempting to add one.
    final existing = spreadsheet.worksheetByTitle(title);
    if (existing != null) return existing;
    return await spreadsheet.addWorksheet(title);
  }

  static Future<SongData?> getByID(String id) async {
    if (_songsSheet == null) return null;

    final json = await _songsSheet!.values.map.rowByKey(id, fromColumn: 1);

    return (json == null) ? null : SongData.fromJson(json);
  }

  static Future<List<SongData>?> getAllRows() async {
    getAllRowsCallCount++;
    if (_songsSheet == null) {
      if (verbose)
        debugPrint(
            'getAllRows (#${getAllRowsCallCount}): songs sheet not initialized');
      return null;
    }

    final sw = Stopwatch()..start();
    try {
      final response = await _songsSheet!.values.map.allRows();
      sw.stop();
      if (response == null) {
        debugPrint(
            'getAllRows (#${getAllRowsCallCount}): API returned null rows (took ${sw.elapsedMilliseconds} ms)');
        return null;
      }

      debugPrint(
          'getAllRows (#${getAllRowsCallCount}): fetched ${response.length} rows (took ${sw.elapsedMilliseconds} ms)');
      lastSuccessfulFetch = DateTime.now();
      return List.from(
          response.map((item) => SongData.fromJson(item)).toList());
    } on GSheetsException catch (e, st) {
      sw.stop();
      debugPrint(
          'getAllRows (#${getAllRowsCallCount}): GSheetsException: $e (took ${sw.elapsedMilliseconds} ms)');
      debugPrint(st.toString());
      return null;
    } catch (e, st) {
      sw.stop();
      debugPrint(
          'getAllRows (#${getAllRowsCallCount}): Error: $e (took ${sw.elapsedMilliseconds} ms)');
      debugPrint(st.toString());
      return null;
    }
  }

  /// Attempts to fetch all rows with retries and exponential backoff on transient errors.
  /// Returns null if unable to fetch after retries.
  static Future<List<SongData>?> getAllRowsWithRetries({
    int maxAttempts = 5,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
    while (attempt < maxAttempts) {
      attempt++;
      if (verbose) debugPrint('getAllRowsWithRetries: attempt #$attempt');
      final rows = await getAllRows();
      if (rows != null) return rows;

      // If null, wait and retry with exponential backoff
      if (attempt < maxAttempts) {
        if (verbose)
          debugPrint(
              'getAllRowsWithRetries: sleeping ${delay.inMilliseconds} ms before retry');
        await Future.delayed(delay);
        delay *= 2;
      }
    }

    debugPrint('getAllRowsWithRetries: failed after $maxAttempts attempts');
    return null;
  }
}
