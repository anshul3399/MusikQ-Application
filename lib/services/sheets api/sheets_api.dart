import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:music_manager/services/model/song_record.dart';

class SheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "musikq-application",
  "private_key_id": "fa89e47ec8d5236deded3ee484f99bdaffb5b5cc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC9HnaQOVOUfps0\n77sJPfc8dDtKFaKPpEqF4CcPTDoUCBDaJQ4tKwlCbQzrLJe/HWrj8JtsIfgT58ve\now70OOFlajg8tRv9wr2jXsIYc/DzBQlfF9z44Duxy/XUxrqRJtyvbYhM4fOIodKH\nWKVhIVHgT+vYIpUXSxChXd0uHY6OWQBnMrio7agmwvCgOwkAohhjRsq5sCRpBZVU\nrYpBraq3+tHZMC22AcC1D5GhU1tXTGuXwPrE681BkD4nbEXisXF1RoBtSR2cRNDr\nUnF+8dm1PU/y+HbfXzSYMnG81gm4QO2y3GG36iRUta2Gsh6WeSaGsqK1lre5CvZw\n/zE7mcirAgMBAAECggEAMXq3ZXuCKQ9I1zxDkKL0PQ5h9rubWP6Qet9PCNsWNOh5\nVEGuqFWiqgzy/NKhbyCotzNbzppCmB6kwb6iqnX5TrnQNd3ikW1yhTxFBvXKnCJ8\ntbL+HuU36QgmbMGDzXc/9Ovw5cCWIXDJLp0cQ8HedJQkbdt6a2o50yZGOIsGIaqn\nBp4J4DZpEK/blDwc/7tgPzjxLWDMHFec3a6CRw0JHyLd4fitst6TsxQFpdD2CIpN\ngOW9XFlYKCof7HLcpLj2N4NVND1gwTnXAmS/fzq6Fy1xriE6+uKvVVspp349tOGO\nf+Nir3DCkrYyRaWY8MoxIgTDMePGjgj1KVsEzIscrQKBgQDuP5pQDdMUMaIPrNY2\nRbkLZdQ7tEwtya/HwWeIVZpIAm4fI/BiH0GBQjvrDjzbDG6rxcRZf5tEdFTtJYyv\nDlS5tmKFECzi400D3XFbjMSIcNqpZSSdUKF8gNPPSk6WhuZXxoh88+NEScQ+CDhH\n7DKp9Qcd4Wi9rL3BAq6vGzArDwKBgQDLNcFxu17/rVw8sBA7m/3qfCZEXY+Y0Gos\nEFpOQHD+v8q3uhnALI5bkTLowUH+tMLFFIT7t2Kqvso/vziMlhCD3wboYuq4lvaO\n6zresJfLaYYLb54hJV54CGb5D/geERA+II4c2JQ71XOoGLx+MNEGU5O3jUEaZaal\nGKwh5LF4pQKBgQCYogK4esLZ0xpiNHZf+rccCDa5sT6ErwuAS/WKMF1Q+M2YAaxF\nEIUkzEwawNpX81ULkv3B4LCWYHjwHPhORj4dZC0l1kELcleqvDmdT0exqatMjtGw\nPzHV06reyFoksXPsk/JpKs5Ut3WT0CxOV5H1tFbE294AdiRy/Mbww9hOHQKBgQCB\nECtEqNS1Xs3uXYRx16l1fFRxp1rEm9pTEi/I83TQ189Q0Yn5XFMuJRJIcjYQJ45s\nzZOIq/imqXaa9kBcShNDLiuc/PZHNtpx+0TwmwhN0T+pk8LDGpDde7irB1F3By9h\nxht8hrHfLrq+ULenDioz8nEnazemJFmrEfiBrlZpYQKBgQCFcMihuyorzCvJAAMt\nwDlUowoGqFgexOvLOi7bl5cCtE+X2IACTkg85OeBUxcAtImKZVeP3AxegUOwy10p\n/nad8Pnqu0sZvcPEx62d9GjKnlbWg67WpzAl7NBPzX0Lm7guXtu7f19XeFMBVAqR\nBaMU8+wFO2zh1A+Erse4zf1SrQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "musikq-application@musikq-application.iam.gserviceaccount.com",
  "client_id": "113923347255031554902",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/musikq-application%40musikq-application.iam.gserviceaccount.com"
}
''';
  static const _spreadsheetId = '1naBPM9m3Di-Ixio8yMjsrB-3DwMudFacxk-oM200ROc';
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
