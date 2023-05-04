import 'package:flutter/material.dart';
import '../widget/LoginCard.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
              height: deviceSize.height * 0.3,
              width: deviceSize.width,
              child: Image.asset("assets/images/title_logo.jpeg")),
          LoginCard()
        ],
      ),
    );
  }
}
