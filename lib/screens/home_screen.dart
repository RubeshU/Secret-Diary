import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/auth.dart';

import './day_note_entry_screen.dart';
import '../services/day_notes.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  fetchNotes() async {
    await Provider.of<DayNotes>(context, listen: false)
        .fetchAndSetNotes(Auth().auth.currentUser!.uid);
  }

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dayNoteList = Provider.of<DayNotes>(context).dayNote;
    return Scaffold(
        appBar: AppBar(
          elevation: 30,
          title: Text('Secret Diary'),
          actions: [
            IconButton(
                onPressed: () {
                  Auth().signOut(context);
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(15),
          child: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(DayNoteEntryScreen.routeName, arguments: '');
            },
          ),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, i) => GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(DayNoteEntryScreen.routeName,
                  arguments: dayNoteList[i].id);
            },
            child: ListTile(
              leading: Container(
                width: 50,
                height: 48,
                color: Colors.blue,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.green,
                      child: Text(
                        DateFormat.MMM()
                            .format(dayNoteList[i].date!)
                            .toString()
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.brown,
                      child: Text(
                        DateFormat.d()
                            .format(dayNoteList[i].date!)
                            .toString()
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.brown,
                      child: Text(
                        DateFormat.y()
                            .format(dayNoteList[i].date!)
                            .toString()
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(dayNoteList[i].title!),
              subtitle: Text(dayNoteList[i].description!.length >= 40
                  ? '${dayNoteList[i].description!.substring(0, 39)}.....'
                  : dayNoteList[i].description!),
            ),
          ),
          itemCount: dayNoteList.length,
        ));
  }
}
