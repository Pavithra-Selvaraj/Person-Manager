import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/persons.dart';
import '../screens/persons_list_screen.dart';
import '../screens/add_person_screen.dart';
import '../screens/person_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Persons(),
      child: MaterialApp(
          title: 'Person Manager',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: const PersonsListScreen(),
          routes: {
            AddPersonScreen.routeName: (ctx) => const AddPersonScreen(),
            PersonDetailScreen.routeName: (ctx) => const PersonDetailScreen()
          }),
    );
  }
}
