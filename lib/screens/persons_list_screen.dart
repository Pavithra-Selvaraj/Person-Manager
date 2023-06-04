import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/persons.dart';

import './add_person_screen.dart';
import 'person_detail_screen.dart';

class PersonsListScreen extends StatelessWidget {
  const PersonsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Person Manager'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPersonScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<Persons>(context, listen: false).fetchAndSetPersons(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Persons>(
                child: const Center(
                  child: Text("Got no persons yet, start adding some!"),
                ),
                builder: (ctx, persons, child) => persons.items.isEmpty
                    ? child!
                    : ListView.builder(
                        itemCount: persons.items.length,
                        itemBuilder: (ctx, index) => Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(persons.items[index].image),
                            ),
                            title: Text(
                              '${persons.items[index].firstName} ${persons.items[index].lastName}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              persons.items[index].gender,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                PersonDetailScreen.routeName,
                                arguments: persons.items[index].id,
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      AddPersonScreen.routeName,
                                      arguments: persons.items[index].id,
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Theme.of(context).primaryColor,
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Person'),
                                        content: const Text(
                                            'Are you sure you want to delete this person?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Provider.of<Persons>(context,
                                                      listen: false)
                                                  .deletePerson(
                                                      persons.items[index].id);
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
