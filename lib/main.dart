import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:test_app/screen_director/authToInfo.dart';
import 'package:test_app/services/notificationservices/local_notification_services.dart';

import '/Screens/welcome.dart';
import '/services/authentication.dart';

import '/widget/wrapper.dart';

import '/Screens/TestScroll.dart';
import './Screens/AboutScreen.dart';

import '/Screens/LoginScreen.dart';
import '/Screens/InformationScreen.dart';
import '/Screens/HomeScreen.dart';

import 'package:flutter/material.dart';
import 'Screens/userUserScreen.dart';
import 'concept/shared.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  await UserSimplePreferences.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: Authentication().isAuthenticated(),
          initialData: null,
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: Color.fromRGBO(107, 185, 226, 1)),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes: {
          AuthToInfo.route: (_) => AuthToInfo(),
          TestScroll.route: (_) => TestScroll(),
          HomeScreen.route: (_) => HomeScreen(),
          LoginScreen.route: (_) => LoginScreen(),
          InformationScreen.route: (_) => InformationScreen(),
          AboutScreen.route: (_) => AboutScreen(),
          AboutUserScreen.route: (_) => AboutUserScreen(),
          Welcome.route: (_) => Welcome(),
        },
      ),
    );
  }
}
