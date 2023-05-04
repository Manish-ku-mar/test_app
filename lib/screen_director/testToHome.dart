import 'package:flutter/material.dart';
import '/Screens/HomeScreen.dart';
import '/Screens/TestScroll.dart';
import '/services/database.dart';

class TestToHome extends StatefulWidget {


  @override
  _TestToHomeState createState() => _TestToHomeState();
}

class _TestToHomeState extends State<TestToHome> {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Database().getPhoneNumber(),
        builder: (BuildContext context,AsyncSnapshot<String>snapshot) {
          switch (snapshot.connectionState) {
            case (ConnectionState.waiting) :
              {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
            default :
              {
                if (snapshot.hasError) {
                  return snackBar;
                }
                else {
                  if (snapshot.data == null) {
                    return TestScroll();
                  }
                  else {
                    return HomeScreen();
                  }
                }
              }
          }
        }
    );
}
}
final snackBar = SnackBar(
  content: const Text('INTRO need contact permission please. '),
  duration: Duration(milliseconds: 1500),
);
