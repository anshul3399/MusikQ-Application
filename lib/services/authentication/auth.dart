import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_manager/screens/authentication/sign_in_widget.dart';
import 'package:music_manager/services/model/app_user.dart';
import 'package:music_manager/services/model/songs_database.dart';

class GoogleSignInProvider extends ChangeNotifier {
  // create user object based on FirebaseUser
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<AppUser?> googleLogin({required BuildContext context}) async {
    try {
      debugPrint("Starting Google Sign In process");

      final googleSignIn = GoogleSignIn();

      // Sign out of existing sessions
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      // Start new sign in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("User cancelled the sign-in process");
        return null;
      }

      debugPrint("Getting Google auth credentials");
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint("Signing in with Firebase");
      final UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = result.user;

      if (user != null) {
        debugPrint("Successfully signed in with Firebase: ${user.uid}");
        _user = googleUser;

        // Create/update user document in Firestore
        final DocumentReference usersRef =
            FirebaseFirestore.instance.collection('userData').doc(user.uid);
        final docSnapshot = await usersRef.get();

        if (!docSnapshot.exists) {
          debugPrint("Creating new user document in Firestore");
          await usersRef.set({
            'email': user.email,
            'appAccessKey': '',
            'userPrivilegeLevel': 0,
            'remotelyDeleteDB': false
          });
        }

        notifyListeners();
        return _userFromFirebaseUser(user);
      } else {
        debugPrint("Failed to get user after Firebase sign in");
        return null;
      }
    } catch (e) {
      debugPrint("[Error]: Exception in google login method - \n$e");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => SignInWidget(
                errorMsg: "Exception in Google Login method.",
              )));
      return null;
    }
  }

  Future googleLogout() async {
    try {
      // Delete the local database first
      await SongsDatabase.instance
          .deleteSongsDB('songs.db', showToastMsg: false);

      // Then sign out from Google and Firebase
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();

      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint("[Error]: Exception in google logout method - \n$e");
    }
  }
}
