import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:music_manager/services/model/song_record.dart';
import 'package:music_manager/services/queryProcessing_LocalDB/query_processing.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SongsDatabase {
  static final SongsDatabase instance = SongsDatabase._init();
  static Database? _database;
  SongsDatabase._init();

  Future<Database> get database async {
    // if (database != null) return _database!;

    _database = await _initDB('songs.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // debugPrint(">>> Initialising Database");
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    // Delete the database
    // await deleteDatabase(path);
    // debugPrint(">> DB deleted");

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableSongs(
  ${SongsDBFields.songID} $idType,
  ${SongsDBFields.albumID} $textType,
  ${SongsDBFields.albumOrSingle} $textType,
  ${SongsDBFields.songTitle} $textType,
  ${SongsDBFields.year} $textType,
  ${SongsDBFields.singers} $textType,
  ${SongsDBFields.musicDirector} $textType,
  ${SongsDBFields.lyricist} $textType,
  ${SongsDBFields.artists} $textType,
  ${SongsDBFields.resourceType} $textType,
  ${SongsDBFields.resourceURL} $textType,
  ${SongsDBFields.thumbnailURL} $textType,
  ${SongsDBFields.primarySearchLabels} $textType,
  ${SongsDBFields.secondarySearchLabels} $textType,
  ${SongsDBFields.likebilityIndex} $textType
)''');
  }

  Future deleteSongsDB(String filePath, {bool showToastMsg = true}) async {
    debugPrint(">>> Deleting Songs Database");
    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, filePath);

      // Delete the database
      await deleteDatabase(path);
      if (showToastMsg) {
        _showToastMessage("Deleted DB");
      }
      debugPrint(">> Songs DB deleted");
    } catch (e) {
      debugPrint("[Exception Occured] : $e");
    }
  }

  Future<SongData> create(SongData song) async {
    final db = await instance.database;
    final id = await db.insert(tableSongs, song.toJson());
    return song.copy(songID: id.toString());
  }

  /// Inserts many songs in a single transaction for better performance.
  Future<void> createMany(List<SongData> songs) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final song in songs) {
        batch.insert(tableSongs, song.toJson());
      }
      await batch.commit(noResult: true);
    });
  }

  Future<SongData> readNode(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSongs,
      columns: SongsDBFields.values,
      where: '${SongsDBFields.songID} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return SongData.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Read all data from local Songs DB
  Future<List<SongData>> readAllSongs() async {
    final db = await instance.database;
    final result = await db.query(tableSongs);
    return result.map((json) => SongData.fromJson(json)).toList();
  }

  // Query Database
  Future<List<SongData>> queryDatabase({
    Map<String, List<String>> selectedItemsMap = const {},
  }) async {
    String fullQueryString = 'SELECT * FROM $tableSongs WHERE ';

    if (checkIfSelectedItemsMapIsEmpty(selectedItemsMap.values.toList())) {
      fullQueryString = 'SELECT * FROM $tableSongs';
    } else {
      selectedItemsMap.forEach((key, value) {
        if (key == "Year") {
          fullQueryString =
              addQueryStringFor_IN_operator(key, value, fullQueryString);
        } else {
          fullQueryString =
              addQueryStringFor_LIKE_operator(key, value, fullQueryString);
        }
      });
    }

    // if (selectedYear.isEmpty &&
    //     selectedSingers.isEmpty &&
    //     selectedMusicDirectors.isEmpty &&
    //     selectedLyricists.isEmpty) {
    //   fullQueryString = 'SELECT * FROM $tableSongs';
    // } else {
    //   for (int i = 0; i < queryItems.length; i++) {
    //     if (i == 0) {
    //       fullQueryString = addQueryStringFor_IN_operator(yearColumnName,
    //           selectedItemsMap[yearColumnName]!, fullQueryString);
    //     } else if (i == 1) {
    //       fullQueryString = addQueryStringFor_LIKE_operator(singersColumnName,
    //           selectedItemsMap[singersColumnName]!, fullQueryString);
    //     } else if (i == 2) {
    //       fullQueryString = addQueryStringFor_LIKE_operator(
    //           musicDirectorColumnName,
    //           selectedItemsMap[musicDirectorColumnName]!,
    //           fullQueryString);
    //     } else {
    //       fullQueryString = addQueryStringFor_LIKE_operator(lyricistColumnName,
    //           selectedItemsMap[lyricistColumnName]!, fullQueryString);
    //     }
    //   }
    // }

    debugPrint(">> Full Query string: $fullQueryString");

    final db = await instance.database;
    final queryResult = await db.rawQuery(fullQueryString);
    debugPrint(">>> Query Result: $queryResult");
    return queryResult.map((json) => SongData.fromJson(json)).toList();
  }

  Future<List> queryForDistinctYears() async {
    try {
      final db = await instance.database;
      final queryResult = await db
          .rawQuery("SELECT DISTINCT Year FROM $tableSongs ORDER BY Year");
      // debugPrint(">>> Query Result: $queryResult");

      Set finalDistinctSet = {};
      for (int i = 0; i < queryResult.length; i++) {
        if (queryResult[i]['Year'].toString().isNotEmpty) {
          finalDistinctSet.add(queryResult[i]['Year']);
        }
      }

      return finalDistinctSet.toList();
    } catch (e) {
      debugPrint(
          "[Error]: Exception in 'queryForDistinctYears()' method - \nException occured while querying to local database.\n$e");
      return ['[ERROR]'];
    }
  }

  Future<List> queryForDistinctConsolidatedvalues(String columnName) async {
    try {
      final db = await instance.database;
      final queryResult = await db.rawQuery(
          "SELECT DISTINCT $columnName FROM $tableSongs ORDER BY $columnName");
      // debugPrint(">>> Consolidated Values Query Result: $queryResult");

      Set<String> finalDistinctSet = {};
      String consolidatedString;
      for (int i = 0; i < queryResult.length; i++) {
        consolidatedString = queryResult[i][columnName].toString();
        if (consolidatedString.contains(',')) {
          // debugPrint(">> Consolidate string contains comma: $consolidatedString");
          List<String> seperateCommasList = consolidatedString.split(',');
          // debugPrint(">> List of strings seperated by comma: ");
          for (int i = 0; i < seperateCommasList.length; i++) {
            // debugPrint(">>\t List item: ${seperateCommasList[i]}");
            String trimmedString = seperateCommasList[i].trim();
            if (trimmedString.isNotEmpty) {
              finalDistinctSet.add(trimmedString);
            }
          }
        } else {
          consolidatedString = consolidatedString.trim();
          if (consolidatedString.isNotEmpty) {
            finalDistinctSet.add(consolidatedString);
          }
        }
      }
      List<String> finalDistinctList = finalDistinctSet.toList();
      finalDistinctList.sort();
      return finalDistinctList;
    } catch (e) {
      debugPrint(
          "[Error]: Exception in 'queryForDistinctConsolidatedvalues()' method - \nException occured while querying to local database.\n$e");
      return ['[ERROR]'];
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// The function checks if all the values inside the selected Items Map are empty
// since if all the items are empty that means no filter is selected therefore
// all the available data should be shown
// Query should be : 'SELECT * FROM $tableSongs'
bool checkIfSelectedItemsMapIsEmpty(List<List> selectedItemsList) {
  bool isEmptyFlag = true;
  for (int i = 0; i < selectedItemsList.length; i++) {
    if (selectedItemsList[i].isNotEmpty) {
      isEmptyFlag = false;
      break;
    }
  }
  return isEmptyFlag;
}

void _showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
  );
}
