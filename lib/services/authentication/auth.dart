import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_manager/screens/authentication/sign_in_widget.dart';
import 'package:music_manager/services/model/app_user.dart';

class GoogleSignInProvider extends ChangeNotifier {
  // create user object based on FirebaseUser
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future? googleLogin({required BuildContext context}) async {
    try {
      final googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      _user = googleUser;

      if (googleUser == null) {
        debugPrint(">> User didn't selected any option from google account.");
        return null;
      } else {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = result.user;

        // if the user doesn't exists, create a new document for the user with the uid
        final DocumentReference usersRef =
            FirebaseFirestore.instance.collection('userData').doc(user!.uid);
        usersRef.get().then((docSnapshot) => {
              if (!docSnapshot.exists)
                {
                  usersRef.set({
                    'email': user.email,
                    'appAccessKey': '',
                    'userPrivilegeLevel': 0,
                    'remotelyDeleteDB': false
                  }) // create the document
                }
            });

        notifyListeners();
        return _userFromFirebaseUser(user);
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
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint("[Error]: Exception in google logout method - \n$e");
    }
  }
}
