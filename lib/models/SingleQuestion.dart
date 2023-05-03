import '../Providers/Option.dart';

class SingleQuestion {
  final String id;

  final String question;
  final List<Option> options;
  int? selectedOptionIndex;
  SingleQuestion(
      {required this.id,
      required this.question,
      required this.options,
      this.selectedOptionIndex});
}
