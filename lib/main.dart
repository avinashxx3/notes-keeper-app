import 'package:flutter/material.dart';
import 'package:notes_keeper/models/user_model.dart';
import 'package:notes_keeper/screens/home.dart';
import 'package:notes_keeper/services/auth.dart';
import 'package:notes_keeper/theme_data/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //initialize firebase connection
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          while (!snapshot.hasData) {
            return Container(child: CircularProgressIndicator());
          }
          return StreamProvider<CustomUser>.value(
            value: AuthService().userStream,
            initialData: null,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Notes Keeper',
              theme: ThemeData(),
              home: HomePage(storage: CounterStorage()),
            ),
          );
        });
  }
}