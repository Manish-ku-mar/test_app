import 'package:flutter/material.dart';
import './HomeScreen.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class Welcome extends StatefulWidget {
  static const String route = '/ShowMarks';

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("INTRO"))),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("WHAT YOU LOOKING FOR HERE :- \n",
                style: TextStyle(fontSize: 15)),
            Text(
                "1. This is an AI powered social media app which describes anyone in just 5 simple words.\n"
                "2. The purpose of this app is to make you know about like minded people just like u.\n"
                "3. And the one who matches your frequency and vibe.\n",
                style: TextStyle(fontSize: 10)),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(HomeScreen.route);
                },
                child: Text("FROM TODAY, I'LL MAKE WISE CHOICES."))
          ],
        ),
      ),
    );
  }
}
