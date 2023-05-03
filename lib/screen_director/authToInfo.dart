
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screen_director/infoToTest.dart';

import '../Screens/LoginScreen.dart';
class AuthToInfo extends StatefulWidget {

  static const String route='/authToInfo';
  @override
  _AuthToInfoState createState() => _AuthToInfoState();
}

class _AuthToInfoState extends State<AuthToInfo> {
  @override
  Widget build(BuildContext context) {
    var auth=Provider.of<User?>(context);
    return auth==null ? LoginScreen() : InfoToTest();
  }
}
