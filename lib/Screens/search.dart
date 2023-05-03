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
import 'searchAboutScreen.dart';
import 'AboutScreen.dart';

class Search extends StatefulWidget {
  @override
  static const String route = "/Search";

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String name = "";
  List<Map<String, dynamic>> data = [];
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
    addData();
  }

  Future<void> disableCapture() async {
    //disable screenshots and record screen in current screen
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('users').add(element);
    }
    print('all data added');
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
            title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        )),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      if (name.isEmpty) {
                        return ListTile(
                          title: Text(
                            "",
                            // maxLines: 1,
                            // overflow: TextOverflow.ellipsis,
                            // style: TextStyle(
                            //     color: Colors.black54,
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text(
                          //   data['email'],
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //       color: Colors.black54,
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(data['image']),
                          // ),
                        );
                      }
                      if (data['user_name']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['user_name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () async {
                            Map<String, dynamic> response = data;
                            print(response);
                            Navigator.of(context).pushNamed(UserScreen.route,
                                arguments: response);
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchAboutScreen(data)));
                          },
                          // subtitle: Text(
                          //   data['email'],
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //       color: Colors.black54,
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(data['image']),
                          // ),
                        );
                      }
                      return Container();
                    });
          },
        ));
  }
}
