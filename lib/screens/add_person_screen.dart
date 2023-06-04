import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:person_manager/models/person.dart';
import 'package:provider/provider.dart';

import '../providers/persons.dart';
import '../widgets/image_input.dart';

class AddPersonScreen extends StatefulWidget {
  static const routeName = '/add-person';

  const AddPersonScreen({Key? key}) : super(key: key);

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  String personId = '';
  bool isEdit = false;

  File? _pickedImage;
  String? selectedGender;
  Person? _person; // The person object being edited

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the person object passed from the previous screen
    personId = (ModalRoute.of(context)!.settings.arguments ?? '') as String;
    if (personId != '') {
      isEdit = true;

      // Find the person object from the provider using the personId
      _person = Provider.of<Persons>(context).findById(personId);

      // Pre-fill the form fields with the existing data
      _firstNameController.text = _person!.firstName;
      _lastNameController.text = _person!.lastName;
      _dobController.text = DateFormat('dd-MM-yyyy').format(_person!.dob);
      selectedGender = _person!.gender;
      _pickedImage = _person!.image;
    }
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePerson() {
    // Checking if all the form details are filled
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all the details.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3)),
      );
      return;
    }

    if (_person != null) {
      // Update the existing person object with the new data
      _person!.firstName = _firstNameController.text;
      _person!.lastName = _lastNameController.text;
      _person!.gender = selectedGender ?? "";
      _person!.dob = DateFormat('dd-MM-yyyy').parse(_dobController.text);
      _person!.image = _pickedImage!;
      Provider.of<Persons>(context, listen: false).updatePerson(
          personId,
          _firstNameController.text,
          _lastNameController.text,
          selectedGender ?? "",
          DateFormat('dd-MM-yyyy').parse(_dobController.text),
          _pickedImage!);
    } else {
      // Create a new person object and add it to the provider
      Provider.of<Persons>(context, listen: false).addPerson(
        _firstNameController.text,
        _lastNameController.text,
        selectedGender ?? "",
        DateFormat('dd-MM-yyyy').parse(_dobController.text),
        _pickedImage!,
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Setting gender dropdown options
    final List<String> genders = ['Female', 'Male', 'Prefer Not to Say'];
    final List<DropdownMenuEntry<String>> genderList =
        <DropdownMenuEntry<String>>[];
    for (final String gender in genders) {
      genderList.add(
        DropdownMenuEntry<String>(value: gender, label: gender),
      );
    }

    return Scaffold(
        appBar: AppBar(
            title:
                isEdit ? const Text('Edit Person') : const Text('Add Person')),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    controller: _firstNameController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    controller: _lastNameController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                      ),
                      readOnly: true,
                      controller: _dobController,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() {
                            _dobController.text = formattedDate;
                          });
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: DropdownMenu(
                        initialSelection: selectedGender,
                        controller: _genderController,
                        label: const Text('Gender'),
                        dropdownMenuEntries: genderList,
                        onSelected: (gender) {
                          setState(() {
                            selectedGender = gender.toString();
                          });
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Profile Image",
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage, selectedImage: _pickedImage),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          )),
          ElevatedButton.icon(
              icon: isEdit ? const Icon(Icons.edit) : const Icon(Icons.add),
              label: isEdit
                  ? const Text('Save Changes')
                  : const Text('Add Person'),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor)),
              onPressed: _savePerson)
        ]));
  }
}
