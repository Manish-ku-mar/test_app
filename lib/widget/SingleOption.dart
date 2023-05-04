import 'package:flutter/material.dart';

import '/Providers/Question.dart';

class SingleOption extends StatefulWidget {
  @override
  final String id;
  final int index;

  SingleOption({required this.id, required this.index});

  @override
  _SingleOptionState createState() => _SingleOptionState();
}

class _SingleOptionState extends State<SingleOption> {
  Color unSelectedColor = Colors.white70;
  Color selectedColor = Colors.green;
  Widget build(BuildContext context) {
    final question = Question();
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Card(
        color: selectedColor,
        child: ListTile(
          onTap: () {
            setState(() {
              //bool currentStatus=question.findById(widget.id!).options[widget.index!].isSelected!;
              question.deSelectOptions(widget.id);
            });
          },
          leading: CircleAvatar(backgroundColor: selectedColor),
          title: Text(
              Question.findById(widget.id).options[widget.index].optionTitle,
              style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
