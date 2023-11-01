import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

//supporting widgets
import 'package:mothers_kitchen/themes.dart';

//screens
import 'package:mothers_kitchen/screens/auth/auth.dart';
import 'package:mothers_kitchen/screens/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //only portrait mode
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mothers Kitchen',
        theme: LightThemes.lightTheme,
        routes: {
          '/auth': (context) => const AuthScreen(),
          // '/signin': (context) => const SignInScreen(),
          // '/signup': (context) => const SignUpScreen(),
          // '/register': (context) => const RegistrationScreen(),
          // '/pwreset': (context) => const ResetPasswordScreen(),
          '/home': (context) => const HomeScreen(),
        },
        home: FirebaseAuth.instance.currentUser == null
            ? const AuthScreen()
            : const HomeScreen());
  }
}
