import 'package:flutter/material.dart';
import 'package:test_app/screen_director/authToInfo.dart';

import 'package:permission_handler/permission_handler.dart';
import '/widget/test.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.contacts.request(), // async work
      builder:
          (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
                child: Image.asset("assets/images/background.jpeg"));
          default:
            if (snapshot.hasError)
              return Container(
                  child: Center(child: Text(snapshot.error.toString())));
            else if (snapshot.data!.isGranted) {
              return AuthToInfo();
            } else {
              return Test();
            }
        }
      },
    );
  }
}
