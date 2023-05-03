class UserDetails {
  String DOB;
  String Gender;
  String Name;
  List<int> a_test_ans;
  int a_test_marks;
  int b_test_marks;
  int c_test_marks;
  String email;
  String phoneNo;
  int total_test_marks;
  String user_group;
  String user_name;
  UserDetails(
      {required this.DOB,
      required this.Gender,
      required this.Name,
      required this.email,
      required this.a_test_ans,
      required this.a_test_marks,
      required this.b_test_marks,
      required this.c_test_marks,
      required this.phoneNo,
      required this.total_test_marks,
      required this.user_group,
      required this.user_name}) {
    // TODO: implement UserDetails
    throw UnimplementedError();
  }
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      DOB: json['DOB'],
      a_test_ans: json['a_test_ans'],
      a_test_marks: json['a_test_marks'],
      b_test_marks: json['b_test_marks'],
      c_test_marks: json['c_test_marks'],
      email: json['email'],
      Gender: json['Gender'],
      Name: json['Name'],
      phoneNo: json['phoneNo'],
      total_test_marks: json['total_test_marks'],
      user_group: json['user_group'],
      user_name: json['user_name'],
    );
  }
  Map<String, dynamic> toJson(UserDetails details) {
    return {
      'DOB': details.DOB,
      'a_test_ans': details.a_test_ans,
      'a_test_marks': details.a_test_marks
    };
  }
}
