import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_manager/screens/authentication/authentication_wrapper.dart';
import 'package:music_manager/services/authentication/auth.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  // await SheetsApi.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => GradientBackgroundTheme()),
    ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
    // ChangeNotifierProvider(
    //   create: (_) => AppConfiguration(appAccessKey: '', accessPIN: ''),
    // ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuiskQ',
      debugShowCheckedModeBanner: false, // To remove the debug banner
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}
