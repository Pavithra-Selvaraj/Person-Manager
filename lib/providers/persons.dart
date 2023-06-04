import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/person.dart';
import '../helpers/db_helper.dart';

class Persons with ChangeNotifier {
  List<Person> _items = [];

  List<Person> get items {
    return [..._items];
  }

  Future<void> addPerson(
    String firstName,
    String lastName,
    String gender,
    DateTime dob,
    File image,
  ) async {
    final newPerson = Person(
        id: DateTime.now().toString(),
        image: image,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dob: dob);
    _items.add(newPerson);
    notifyListeners();
    DBHelper.insert('persons', {
      'id': newPerson.id,
      'first_name': newPerson.firstName,
      'last_name': newPerson.lastName,
      'gender': newPerson.gender,
      'dob': DateFormat('yyyy-MM-dd').format(newPerson.dob),
      'image': newPerson.image.path,
    });
  }

  Future<void> updatePerson(
    String id,
    String firstName,
    String lastName,
    String gender,
    DateTime dob,
    File image,
  ) async {
    final personIndex = _items.indexWhere((person) => person.id == id);

    if (personIndex >= 0) {
      final updatedPerson = Person(
        id: id,
        image: image,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dob: dob,
      );

      _items[personIndex] = updatedPerson;
      notifyListeners();

      await DBHelper.update(
          'persons',
          {
            'id': updatedPerson.id,
            'first_name': updatedPerson.firstName,
            'last_name': updatedPerson.lastName,
            'gender': updatedPerson.gender,
            'dob': DateFormat('yyyy-MM-dd').format(updatedPerson.dob),
            'image': updatedPerson.image.path,
          },
          id);
    }
  }

  Future<void> deletePerson(String id) async {
    await DBHelper.delete('persons', 'id', id);
    _items.removeWhere((person) => person.id == id);
    notifyListeners();
  }

  Future<void> fetchAndSetPersons() async {
    final dataList = await DBHelper.getData('persons');
    _items = dataList
        .map((item) => Person(
            id: item['id'],
            firstName: item['first_name'],
            lastName: item['last_name'],
            gender: item['gender'],
            dob: DateTime.parse(item['dob']),
            image: File(item['image'])))
        .toList();
    notifyListeners();
  }

  Person findById(String id) {
    return _items.firstWhere((person) => person.id == id);
  }
}
