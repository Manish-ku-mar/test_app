import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_app/Screens/userUserScreen.dart';
import 'package:test_app/concept/shared.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../services/notificationservices/local_notification_services.dart';
import '/services/authentication.dart';
import '/services/database.dart';
import '/widget/contactList.dart';

import 'package:flutter/material.dart';
import 'search.dart';
import 'AboutScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  static const String route = "/homeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();

    //contacts==null ? print("0"):print(contacts!.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disableCapture();
  }

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text("INTRO App")),
          leading: GestureDetector(
            onTap: () async {
              Map<String, dynamic> response =
                  await Database().getCurrentUserGroup();
              print(response);
              Navigator.of(context)
                  .pushNamed(AboutUserScreen.route, arguments: response);
            },
            child: Icon(
              Icons.account_circle,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Search()));
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () async {
                  Authentication().signOut(context);
                  UserSimplePreferences.erase();
                },
                icon: Icon(Icons.logout))
          ]),
      body: Align(
        alignment: Alignment.topLeft,
        child: ContactList(),
      ),
    );
  }
}
