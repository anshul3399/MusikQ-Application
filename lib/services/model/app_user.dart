class AppUser {
  final String uid;
  AppUser({required this.uid});
}

class UserData {
  final String uid;
  final String email;
  final String appAccessKey;
  final int userPrivilegeLevel;
  final bool remotelyDeleteDB;

  //constructor
  UserData(
      {required this.uid,
      required this.email,
      required this.appAccessKey,
      required this.userPrivilegeLevel,
      required this.remotelyDeleteDB});
}
