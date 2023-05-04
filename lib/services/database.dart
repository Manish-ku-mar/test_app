import 'dart:convert';
import 'dart:ffi';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:test_app/concept/shared.dart';
import 'package:test_app/services/authentication.dart';

import './contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '/concept/classifier.dart';

class Database with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<String>  getName(String uid) async{
  //
  //  String name= await
  //  Database().basicInformationAvailable(uid);
  //  return name;
  // }
  // Future<String>  getPhone(String uid) async{
  //
  //   String phoneNo;
  //   phoneNo=await Database().getPhoneNumber(uid);
  //   return phoneNo;
  // }

  Future<String?>? basicInformationAvailable() async {
    String? uid = Authentication().userId();
    print("uid inside basic info available");
    print(uid);

    DocumentSnapshot snapshot =
        await firestore.collection("user").doc(uid).get();
    print(snapshot.data());
    if (snapshot.data() == null) return null;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    print("name got ");
    print(data['Name']);
    return data['Name'];
  }

  Future<Map<String, dynamic>> getCurrentUserGroup() async {
    String? uid = Authentication().userId();
    if (uid == null) uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await firestore.collection("user").doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> userData = {};
    userData = data.map((key, value) {
      if (key == "a_test_ans") {
        List<int> ans = [];
        for (int i = 0; i < value.length; i++) {
          ans.add(value[i]);
        }
        return MapEntry(key, ans);
      }
      return MapEntry(key, value);
    });

    return userData;
  }

  Future<String> getPhoneNumber() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot =
        await firestore.collection('user').doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    print("phone number gets called");
    print(data['phoneNo']);
    return data['phoneNo'];
  }

  Future<List<Map<String, dynamic>>> dataFetcher() async {
    Set<String> _phonesSet = {};
    try {
      List<String> _phones = await Contacts().getPhoneNumbers();

      for (int i = 0; i < _phones.length; i++) {
        _phonesSet.add(_phones[i]);
      }
    } on Exception catch (e) {
      // TODO
      throw e;
    }

    QuerySnapshot snapshot =
        await firestore.collection('user').orderBy('Name').get();
    // print(snapshot);
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    User? user = FirebaseAuth.instance.currentUser;

    String? phoneNumber = user == null ? null : user.phoneNumber;
    List<Map<String, dynamic>> correct = [];
    for (int i = 0; i < documents.length; i++) {
      var doc = documents[i];
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String numberFromFirebase = data['phoneNo'];
      String phoneWithoutCountryCode = numberFromFirebase.substring(3);
      print(numberFromFirebase);
      print(phoneWithoutCountryCode);
      if (data['phoneNo'] == phoneNumber ||
          ((_phonesSet.contains(numberFromFirebase) == false))) continue;

      correct.add(data.map((key, value) {
        if (key == "a_test_ans") {
          List<int> answers = [];
          for (int i = 0; i < value.length; i++) {
            answers.add(value[i]);
          }
          return MapEntry(key, answers);
        } else {
          return MapEntry(key, value.toString());
        }
      }));
    }
    return correct;
  }

  Future<List<String>> getUserName() async {
    List<String> username = [];
    final snapshot = await firestore.collection('user').get();
    // snapshot.forEach((element) {element.docs.forEach((data) {data.data()[]})});
    // snapshot.data()!.forEach((key, value) {
    //   if (key == "user_name") {
    //     username.add(value);
    //   }
    // });
    // print(username);
    final list = snapshot.docs.map((e) => e.data()).toList();
    list.forEach((element) {
      username.add(element["user_name"].toString());
    });
    // print(snapshot.data());
    return username;
  }

  Future<void> userTestMarksDataUpload(
    int a_marks,
    int b_marks,
    int c_marks,
    int total_marks,
    List<int> a_test_ans,
  ) async {
    String? uid = Authentication().userId();
    DocumentSnapshot snapshot =
        await firestore.collection("user").doc(uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data == null) return null;
    String? phoneNumber = Authentication().getPhoneNumber();
    print("phone Number");
    print(phoneNumber);
    if (data['Gender'] == "Male") {
      total_marks -= a_marks;
      a_marks = 54 - a_marks;
      total_marks += a_marks;
    }
    String userGroup = Classifier()
        .classGroup(a_marks + b_marks + c_marks, a_marks, b_marks, c_marks);
    try {
      await firestore.collection("user").doc(uid).set({
        'UID': data["UID"],
        'phoneNo': phoneNumber,
        'Name': data['Name'],
        'DOB': data['DOB'],
        'Gender': data['Gender'],
        'a_test_marks': a_marks,
        'b_test_marks': b_marks,
        'c_test_marks': c_marks,
        'total_test_marks': total_marks,
        'a_test_ans': a_test_ans,
        'user_group': userGroup,
        'user_name': data['user_name']
      });
    } on Exception catch (e) {
      // TODO
      rethrow;
    }
  }

// fun to upload user personal data to databse
  Future<void> userPersonalDataUpload(
      String name, String gender, DateTime dob, String username) async {
    String? uid = Authentication().userId();
    try {
      await firestore.collection("user").doc(uid).set({
        'UID': uid,
        'Name': name,
        'Gender': gender,
        'DOB': dob.toString(),
        'user_name': username,
      });
    } on Exception catch (e) {
      // TODO
      rethrow;
    }
  }

  Future<void> postNotification(BuildContext context) async {
    Contacts _contacts = Contacts();
    List<String> _phones = await _contacts.getPhoneNumbers();
    print(_phones);

    String? uid = Authentication().userId();
    try {
      await firestore.collection("user").get().then((value) {
        value.docs.forEach((element) {
          if (element.data().containsKey("token")) {
            String token = element.get("token");
            String number = element.get("phoneNo");
            String? name = UserSimplePreferences.getName();

            if (token != null) {
              if (_phones.contains(number)) {
                print(number);
                print(name);
                String body = "$name is now on INTRO APP";
                String title = "INTRO APP";

                sendMessage(element.get("token"), body, title);
              }
            }
          }
        });
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Message Sent")));
    } on Exception catch (e) {
      // TODO
      rethrow;
    }
  }

  Future<void> uploadFCMToken(String token) async {
    String? uid = Authentication().userId();
    try {
      await firestore.collection("user").doc(uid).update({'token': token});
    } on Exception catch (e) {
      // TODO
      rethrow;
    }
  }

  Future<String> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    String deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
    return deviceTokenToSendPushNotification;
  }

  void sendMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA8A6JXn8:APA91bHDjDbTHzsbnmcBa2s2WrFW6LeneOxPKCLsgRpKPo7vXmqOGoG2Wd6bBtRqW1QItx9mKUqBf8BA8sXDFATvwgNWVy_-DVhZtxiQo-STODUQPiLjy3GogyM2RWcDjMK28SWmkan1',
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'test app',
              },
              'to': token,
            },
          ));
    } catch (e) {
      print(e);
      print("error");
    }
  }
}
