import 'package:flutter/material.dart';

import '/Providers/Question.dart';
import '../models/SingleQuestion.dart';

enum AvailOptions { option1, option2, option3, option4, option5 }

class OptionCard extends StatefulWidget {
  final int _selectedIndex;

  @override
  OptionCard(this._selectedIndex);

  @override
  _OptionCardState createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  AvailOptions getOption(int index) {
    if (index == 0) return AvailOptions.option1;
    if (index == 1) return AvailOptions.option2;
    if (index == 2) return AvailOptions.option3;
    if (index == 3) return AvailOptions.option4;
    return AvailOptions.option5;
  }

  int getIndex(AvailOptions option) {
    if (option == AvailOptions.option1) return 0;
    if (option == AvailOptions.option2) return 1;
    if (option == AvailOptions.option3) return 2;
    if (option == AvailOptions.option4) return 3;
    return 4;
  }

  Widget build(BuildContext context) {
    SingleQuestion quest = Question.questions[widget._selectedIndex];

    AvailOptions _selectedOption = quest.selectedOptionIndex == null
        ? AvailOptions.option5
        : getOption(quest.selectedOptionIndex!);
    return Container(
        //width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _selectedOption = AvailOptions.option1;
                });
                if (_selectedOption != null) {
                  quest.selectedOptionIndex = getIndex(_selectedOption);
                }
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: _selectedOption == AvailOptions.option1
                            ? Colors.green
                            : Colors.black,
                        width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: _selectedOption == AvailOptions.option1
                      ? Colors.green[400]
                      : Colors.white,
                  title: Text(quest.options[0].optionTitle),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedOption = AvailOptions.option2;
                });
                if (_selectedOption != null) {
                  quest.selectedOptionIndex = getIndex(_selectedOption);
                }
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: _selectedOption == AvailOptions.option2
                            ? Colors.green
                            : Colors.black,
                        width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: _selectedOption == AvailOptions.option2
                      ? Colors.green[400]
                      : Colors.white,
                  title: Text(quest.options[1].optionTitle),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedOption = AvailOptions.option3;
                });
                if (_selectedOption != null) {
                  quest.selectedOptionIndex = getIndex(_selectedOption);
                }
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: _selectedOption == AvailOptions.option3
                            ? Colors.green
                            : Colors.black,
                        width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: _selectedOption == AvailOptions.option3
                      ? Colors.green[400]
                      : Colors.white,
                  title: Text(quest.options[2].optionTitle),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    _selectedOption = AvailOptions.option4;
                  });
                  if (_selectedOption != null) {
                    quest.selectedOptionIndex = getIndex(_selectedOption);
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: _selectedOption == AvailOptions.option4
                              ? Colors.green
                              : Colors.black,
                          width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: _selectedOption == AvailOptions.option4
                        ? Colors.green[400]
                        : Colors.white,
                    title: Text(quest.options[3].optionTitle),
                  ),
                )),
          ],
        ));
  }
}
