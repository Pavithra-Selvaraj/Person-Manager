import 'dart:io';

class Person {
  String id;
  String firstName;
  String lastName;
  String gender;
  DateTime dob;
  File image;

  Person(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.dob,
      required this.image});
}
