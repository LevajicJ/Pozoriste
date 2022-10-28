import 'package:flutter/material.dart';
import 'package:pozoriste/Screens/backgroud.dart';
import 'package:pozoriste/Screens/konekcija.dart';
import 'Screens/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
   Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF900020)
        ),
        primaryColor: const Color(0xFF900020),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Konekcija(),
    );
  }
}
