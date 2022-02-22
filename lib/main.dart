import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secret_diary_two/services/day_notes.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/auth_screen.dart';
import './services/auth.dart';
import './screens/home_screen.dart';
import './screens/day_note_entry_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DayNotes(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            accentColor: Colors.amber,
          ),
          routes: {
            DayNoteEntryScreen.routeName: (ctx) => DayNoteEntryScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
          },
          home: FutureBuilder(
            future: Auth().getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return AuthScreen();
              }
            },
          )),
    );
  }
}
