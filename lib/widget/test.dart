import 'package:flutter/material.dart';
import '/services/contacts.dart';
import 'package:permission_handler/permission_handler.dart';
class Test extends StatelessWidget {
  var contactStatus=Permission.contacts.status;
  @override
  Widget build(BuildContext context) {
    return Container(child:ElevatedButton(child: Text("Please Provide Contact Permission") ,onPressed :()async{
     await Permission.contacts.request();
      if(await contactStatus.isGranted){
        final list=await Contacts().requiredPhoneNumbers();
      }

    }));
  }
}
