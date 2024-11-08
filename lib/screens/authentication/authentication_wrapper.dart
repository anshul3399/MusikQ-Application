// This is the wrapper widget, which continiously listens to a stream to check if user is
// signed in or not and based on that loads the particular widget
// if signed in then - HomePage()
// otherwise - SignUpPage()

import 'package:flutter/material.dart';
import 'package:music_manager/screens/authentication/sign_in_widget.dart';
import 'package:music_manager/screens/primaryScreens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_manager/services/AppConfigsDatabase/firestore_app_configs_database.dart';
import 'package:music_manager/services/model/app_configuration.dart';
import 'package:music_manager/services/model/app_user.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return MultiProvider(
                providers: [
                  // Application Configuration Data Stream Provider
                  StreamProvider<AppConfiguration>.value(
                    initialData: AppConfiguration(
                        appAccessKey: '', accessPIN: '', deleteDB: false),
                    value: ApplicationConfigurationsDatabaseService()
                        .appConfigurationData,
                  ),
                  // User Data Stream Provider
                  StreamProvider<UserData>.value(
                    initialData: UserData(
                        uid: '',
                        email: '',
                        appAccessKey: '',
                        userPrivilegeLevel: 0,
                        remotelyDeleteDB: false),
                    value: UserDatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .userData,
                  ),
                ],
                child: HomePage(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong! :("),
              );
            } else {
              return SignInWidget();
            }
          }),
    );
  }
}
