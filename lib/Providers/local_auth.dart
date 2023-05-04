// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// class LocalAuth with ChangeNotifier{
//
//   Future<void> setPhoneNumber(String phone) async{
//     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
//     sharedPreferences.setString("PHONE", phone);
//
//   }
//   Future<String>get getPhoneNumber async{
//     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
//     return sharedPreferences.getString("PHONE");
//   }
//
//   Future<void> storeUserId() async{
//     User user=FirebaseAuth.instance.currentUser;
//     if(user==null){
//       return ;
//     }
//     print("storing user id");
//
//     SharedPreferences sharedPreferences= await SharedPreferences.getInstance() ;
//     sharedPreferences.setString('ID',user.uid );
//     print(sharedPreferences.getString('ID'));
//
//     return ;
//   }
//   Future<void> localSignOut()async{
//     SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
//     sharedPreferences.remove('ID');
//     sharedPreferences.remove('PHONE');
//     print("notified listeners");
//     notifyListeners();
//   }
// }