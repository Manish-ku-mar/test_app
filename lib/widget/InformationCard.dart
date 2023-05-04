import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/concept/shared.dart';
import 'show_error.dart';
import 'package:test_app/widget/show_error.dart';
import '../services/database.dart';
import '../Screens/TestScroll.dart';

class InformationCard extends StatefulWidget {
  @override
  State<InformationCard> createState() => _InformationCardState();
}

enum Gender { Male, Female, Other, NotSelected }

class _InformationCardState extends State<InformationCard> {
  @override
  initState() {
    super.initState();
    print("initstate called");
    getUsers();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _unameController = new TextEditingController();

  List<String> users = [];
  Gender _selectedGender = Gender.NotSelected;

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1960, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> getUsers() async {
    users = await Database().getUserName();
    print('users are $users');
  }

  int dobToAge(String birthDateString) {
    String datePattern = 'dd-MM-yyyy';

    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //String userId = ModalRoute.of(context)!.settings.arguments as String;
    bool isLoading = false;
    Future<void> saveForm() async {
      await getUsers();
      if (!_formKey.currentState!.validate()) {
        print("errororoorororo ooroororo");
        return;
      }
      if (_selectedGender == Gender.NotSelected) {
        ShowError().showErrorDialog(context, "Please Select your gender");

        return;
      }
      String g = _selectedGender == Gender.Male
          ? "Male"
          : _selectedGender == Gender.Female
              ? "Female"
              : "Other";
      setState(() {
        isLoading = true;
      });
      try {
        await Database().userPersonalDataUpload(
            _nameController.text, g, selectedDate, _unameController.text);
      } catch (e) {
        ShowError().showErrorDialog(context, e.toString());
      }
      setState(() {
        isLoading = false;
      });
      UserSimplePreferences.setName(_nameController.text);
      Navigator.of(context).pushReplacementNamed(TestScroll.route);
    }

    return isLoading == true
        ? CircularProgressIndicator()
        : Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: size.width,
              height: size.height,
              color: Color.fromRGBO(255, 255, 255, 0.8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: "Enter Your Name",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) return "Not a Valid Name";
                              return null;
                            },
                            controller: _nameController,
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: "Enter Your User Name",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                            validator: (value) {
                              if (value == null) return "Not a Valid Name";
                              for (int i = 0; i < users.length; i++) {
                                if (users[i] == value.toString()) {
                                  return "username already exists";
                                }
                              }
                              return null;
                            },
                            controller: _unameController,
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    "Gender",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: ListTile(
                                        leading: Radio<Gender>(
                                          value: Gender.Male,
                                          groupValue: _selectedGender,
                                          onChanged: (Gender? gender) {
                                            setState(() {
                                              _selectedGender = gender!;
                                            });
                                          },
                                        ),
                                        title: Text("Male"),
                                      ),
                                    ),
                                    Flexible(
                                      child: ListTile(
                                        leading: Radio<Gender>(
                                          value: Gender.Female,
                                          groupValue: _selectedGender,
                                          onChanged: (Gender? gender) {
                                            setState(
                                              () {
                                                _selectedGender = gender!;
                                              },
                                            );
                                          },
                                        ),
                                        title: Text("Female"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text("Select Your DOB"),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.05,
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () async {
                                await saveForm();
                              },
                              child: Text("Submit"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
