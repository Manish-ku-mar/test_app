import 'package:contacts_service/contacts_service.dart';

class Contacts {
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);
    return contacts;
  }

  Future<List<Item>> requiredPhoneNumbers() async {
    List<Item> _phones = [];
    List<Contact> _contacts = await getContacts();
    _contacts.forEach((element) {
      if (element.phones != null) {
        element.phones?.forEach((phone) {
          _phones.add(phone);
        });
      }
    });
    return _phones;
  }

  String formatPhone(String s) {
    s = s.replaceAll(
        RegExp(
          '-',
        ),
        '');
    s = s.replaceAll(
        RegExp(
          ' ',
        ),
        '');
    return s;
  }

  Future<List<String>> getPhoneNumbers() async {
    List<String> _phones = [];
    List<Contact> _contacts = await getContacts();
    _contacts.forEach((element) {
      if (element.phones != null) {
        element.phones?.forEach((phone) {
          print("${phone.label}--${phone.value}");
          String number = formatPhone(phone.value.toString());
          print(number.startsWith("+91"));
          if (!number.startsWith("+91")) {
            number = "+91" + number;

            _phones.add(number);
          } else {
            _phones.add(number);
          }
        });
      }
    });
    return _phones;
  }
}
