import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_manager/services/model/app_configuration.dart';
import 'package:music_manager/services/model/app_user.dart';

class ApplicationConfigurationsDatabaseService {
  //collection reference
  final CollectionReference appConfigCollection =
      FirebaseFirestore.instance.collection("applicationConfiguration_DB");

  //user data from snapshot
  AppConfiguration _appConfigurationDataFromSnapshot(
      DocumentSnapshot snapshot) {
    return AppConfiguration(
        appAccessKey: snapshot.get('appAccessKey') ?? '',
        accessPIN: snapshot.get('accessPIN') ?? '',
        deleteDB: snapshot.get('deleteDB') ?? false);
  }

  //get app config doc stream
  Stream<AppConfiguration> get appConfigurationData {
    return appConfigCollection
        .doc('AppData')
        .snapshots()
        .map(_appConfigurationDataFromSnapshot);
  }
}

class UserDatabaseService {
  final String uid;
  UserDatabaseService({required this.uid});

  //collection reference
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection("userData");

  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        email: snapshot.get('email') ?? '',
        appAccessKey: snapshot.get('appAccessKey') ?? '',
        userPrivilegeLevel: snapshot.get('userPrivilegeLevel') ?? 0,
        remotelyDeleteDB: snapshot.get('remotelyDeleteDB') ?? false);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userDataCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
