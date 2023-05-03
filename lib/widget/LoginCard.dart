import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:test_app/services/contacts.dart';

import '../Providers/local_auth.dart';
import '/services/authentication.dart';
import '/widget/show_error.dart';

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _isLoading = false;

  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _verificationId, smsCode;
  int? _resendToken;
  bool codeSentToUser = false;

  void dispose() {
    // TODO: implement dispose

    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitPhoneNumber(String phoneNo) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    String phoneNumber = "+91 " + phoneNo;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(milliseconds: 10000),
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              await auth.signInWithCredential(credential);
            } on Exception catch (e) {
              // TODO
              ShowError().showErrorDialog(context, e.toString());
            }
          },
          verificationFailed: (FirebaseAuthException error) async {
            ShowError().showErrorDialog(context, error.code);
          },
          codeSent: (String verificationId, int? resendToken) async {
            setState(() {
              codeSentToUser = true;
            });
            _verificationId = verificationId;
            _resendToken = resendToken!;
          },
          forceResendingToken: _resendToken,
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = _verificationId;
          });
    } on Exception catch (e) {
      ShowError().showErrorDialog(context, e.toString());
      // TODO
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double appBarHeight = AppBar().preferredSize.height;
    return _isLoading == true
        ? Center(child: CircularProgressIndicator())
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8.0,
            child: Scrollbar(
              child: Container(
                width: deviceSize.width,
                height: deviceSize.height * 0.64 - appBarHeight,
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Text("Welcome",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Contact Number',
                              prefixIcon: Icon(Icons.add_call)),
                          validator: (value) {
                            if (value == null)
                              return 'Number cannot be Empty!!';
                            if (value.isEmpty || value.length != 10) {
                              return 'Invalid Mobile Number';
                            }
                            return null;
                          },
                          controller: _contactController,
                        ),
                        if (codeSentToUser)
                          Column(
                            children: [
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: 'Enter OTP Sent to this number',
                                    prefixIcon: Icon(Icons.password)),
                                keyboardType: TextInputType.number,
                              ),
                              TextButton(
                                  onPressed: () {
                                    _submitPhoneNumber(_contactController.text);
                                  },
                                  child: Text("Resend OTP"))
                            ],
                          ),
                        SizedBox(height: deviceSize.height * 0.06),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(StadiumBorder()),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25))),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (codeSentToUser) {
                                try {
                                  await Authentication().verifyPhoneNumber(
                                      _verificationId!,
                                      _passwordController.text);
                                } on Exception catch (e) {
                                  // TODO
                                  ShowError()
                                      .showErrorDialog(context, e.toString());
                                }
                              } else {
                                _submitPhoneNumber(_contactController.text);
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: codeSentToUser == true
                                ? Text("Verify User")
                                : Text("Log In")),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
