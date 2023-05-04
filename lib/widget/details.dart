import 'package:flutter/material.dart';

import '../models/details.dart';

class DetailsCard extends StatefulWidget {
  String? image;
  String? title;
  String? Description;
  DetailsCard(
      {required this.image, required this.title, required this.Description});

  @override
  State<DetailsCard> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage(widget.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .1,
                padding:EdgeInsets.only(left: 10, right: 10, bottom: 10) ,
                child: Center(

                    child: Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * .25,
                  child: Center(
                    child: Text(widget.Description! ,textAlign: TextAlign.justify,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
