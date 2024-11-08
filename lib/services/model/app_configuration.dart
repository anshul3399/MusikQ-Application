class AppConfiguration {
  final String appAccessKey;
  final String accessPIN;
  final bool deleteDB;

  AppConfiguration(
      {required this.appAccessKey,
      required this.accessPIN,
      required this.deleteDB});
}
