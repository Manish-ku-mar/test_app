import 'package:flutter/material.dart';
import '/screen_director/testToHome.dart';
import '/Screens/InformationScreen.dart';

import '/services/database.dart';

class InfoToTest extends StatefulWidget {
  @override
  _InfoToTestState createState() => _InfoToTestState();
}

class _InfoToTestState extends State<InfoToTest> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: Database().basicInformationAvailable(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          switch (snapshot.connectionState) {
            case (ConnectionState.waiting):
              {
                return CircularProgressIndicator();
              }
            default:
              {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  if (!snapshot.hasData) {
                    return InformationScreen();
                  } else {
                    return TestToHome();
                  }
                }
              }
          }
        });
  }
}
