import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/services/database.dart';

import '../Screens/AboutScreen.dart';

class ContactList extends StatelessWidget {
  List<Map<String, dynamic>>? contacts;

  ContactList();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchData() async {
    print("fettcihing dataaata");
    contacts = await Database().dataFetcher();
    print("fetched data");
    print(contacts);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('new').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error"));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;

            default:
              {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  builder: (context, dataSnapshot) {
                    if (dataSnapshot.hasError) return Text("error");
                    switch (dataSnapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                        break;
                      default:
                        {
                          return dataSnapshot.data == null
                              ? Center(child: Text("NO DATA"))
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ColoredBox(
                                        color: Colors.lightBlue,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          primary: false,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black)),
                                              child: ListTile(
                                                leading: Icon(Icons
                                                    .supervised_user_circle_outlined),
                                                tileColor: Colors.black12,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    side: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 0.5)),
                                                title: Text(dataSnapshot
                                                    .data![index]['Name']),
                                                onTap: () {
                                                  print(dataSnapshot
                                                      .data![index]);
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          AboutScreen.route,
                                                          arguments:
                                                              dataSnapshot
                                                                      .data![
                                                                  index]);
                                                },
                                              ),
                                            );
                                          },
                                          itemCount: dataSnapshot.data!.length,
                                        ),
                                      ),
                                      Text(
                                          "Ask your friends and nearby people to download INTRO app to know about them."),
                                    ],
                                  ),
                                );
                        }
                    }
                  },
                  future: Database().dataFetcher(),
                );
              }
          }
        });
  }
}
