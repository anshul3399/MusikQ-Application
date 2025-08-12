// This is an example file showing the structure of credentials.dart
// Copy this file to credentials.dart and fill in your actual credentials

class GoogleSheetsCredentials {
  static const credentials = r'''
{
  "type": "service_account",
  "project_id": "example-project-id",
  "private_key_id": "example-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\nYour-Private-Key\n-----END PRIVATE KEY-----\n",
  "client_email": "example@project.iam.gserviceaccount.com",
  "client_id": "123456789",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/example"
}
''';

  static const spreadsheetId = 'example-spreadsheet-id';
}
