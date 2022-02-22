import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/day_note.dart';

class DayNotes with ChangeNotifier {
  List<DayNote> _dayNotes = [];

  List<DayNote> get dayNote {
    return [..._dayNotes];
  }

  void printLen() {
    print(_dayNotes.length);
  }

  addDayNote(DayNote dayNote, String userId) async {
    String id = randomAlphaNumeric(15);
    _dayNotes.insert(
        0, DayNote(id, dayNote.date, dayNote.title, dayNote.description));
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(id)
        .set({
      'id': id,
      'date': dayNote.date?.toIso8601String(),
      'title': dayNote.title,
      'description': dayNote.description
    });
    notifyListeners();
  }

  fetchAndSetNotes(String userId) async {
    var snapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get();
    DocumentSnapshot s;
    for (int i = 0; i < snapshots.docs.length; i++) {
      s = snapshots.docs[i];
      _dayNotes.add(DayNote(
          s['id'], DateTime.parse(s['date']), s['title'], s['description']));
      print(DateTime.parse(s['date']).toString());
    }
    print(DateTime.now().toString());

    notifyListeners();
  }

  updateDayNote(DayNote dayNoteItem, String userId) async {
    final index =
        _dayNotes.indexWhere((dayNoteEle) => dayNoteEle.id == dayNoteItem.id);
    if (index >= 0) {
      _dayNotes[index] = dayNoteItem;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(dayNoteItem.id)
        .set({
      'id': dayNoteItem.id,
      'date': dayNoteItem.date?.toIso8601String(),
      'title': dayNoteItem.title,
      'description': dayNoteItem.description,
    });
    print(_dayNotes.length);
    notifyListeners();
  }

  DayNote getDayNoteById(String id) {
    return _dayNotes.firstWhere((dayNoteEle) => dayNoteEle.id == id);
  }
}
