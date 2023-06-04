import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/persons.dart';
import 'add_person_screen.dart';

class PersonDetailScreen extends StatelessWidget {
  static const routeName = '/person-detail';

  const PersonDetailScreen({Key? key}) : super(key: key);

  Widget _buildDetailRow(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final selectedPerson =
        Provider.of<Persons>(context, listen: false).findById(id);

    void editPerson() {
      Navigator.of(context).pushNamed(AddPersonScreen.routeName, arguments: id);
    }

    void showDeleteConfirmationDialog() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Person'),
          content: const Text('Are you sure you want to delete this person?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<Persons>(context, listen: false).deletePerson(id);
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedPerson.firstName} ${selectedPerson.lastName}'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 350,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.file(
                selectedPerson.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('First Name:', selectedPerson.firstName),
              _buildDetailRow('Last Name:', selectedPerson.lastName),
              _buildDetailRow(
                'Date of Birth:',
                DateFormat('dd-MM-yyyy').format(selectedPerson.dob),
              ),
              _buildDetailRow('Gender:', selectedPerson.gender),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: editPerson,
                  child: const Text('Edit'),
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                  onPressed: showDeleteConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                )),
              ],
            )),
      ]),
    );
  }
}
