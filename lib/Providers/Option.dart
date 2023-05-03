import 'package:flutter/material.dart';

class Option with ChangeNotifier {
  int optionId;
  String optionTitle;

  int marks;

  Option(
      {required this.optionId, required this.marks, required this.optionTitle});
}
