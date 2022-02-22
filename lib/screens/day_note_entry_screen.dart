import 'package:flutter/material.dart';
import '../models/day_note.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/day_notes.dart';
import '../services/auth.dart';

class DayNoteEntryScreen extends StatefulWidget {
  static const routeName = '/day-note-entry-screen';
  @override
  _DayNoteEntryScreenState createState() => _DayNoteEntryScreenState();
}

class _DayNoteEntryScreenState extends State<DayNoteEntryScreen> {
  var isInit = true;
  DayNote initialObjVal = DayNote('', DateTime.now(), '', '');
  var isUpdate = false;
  final _form = GlobalKey<FormState>();
  void showDatePickerWindow() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickeddate) {
      if (pickeddate == null) {
        return;
      }
      setState(() {
        initialObjVal.date = pickeddate;
      });
    });
  }

  void save() {
    final isvalid = _form.currentState?.validate();
    if (isvalid == false) {
      return;
    }
    _form.currentState?.save();
    if (isUpdate == false) {
      Provider.of<DayNotes>(context, listen: false)
          .addDayNote(initialObjVal, Auth().auth.currentUser!.uid);
    } else {
      Provider.of<DayNotes>(context, listen: false)
          .updateDayNote(initialObjVal, Auth().auth.currentUser!.uid);
    }
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      String id = ModalRoute.of(context)!.settings.arguments as String;
      if (id == '') {
        return;
      }
      initialObjVal = Provider.of<DayNotes>(context).getDayNoteById(id);
      isInit = true;
      isUpdate = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Note'),
        actions: [
          IconButton(
              onPressed: () {
                save();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
              key: _form,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: showDatePickerWindow,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined),
                          SizedBox(
                            width: 8,
                          ),
                          Text(DateFormat.yMMMMEEEEd()
                              .format(initialObjVal.date!)
                              .toString())
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 7),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextFormField(
                      style: TextStyle(fontSize: 16),
                      initialValue: initialObjVal.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (titleValue) {
                        if (titleValue == '') {
                          return 'Please Provide some title!';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newTitleValue) {
                        initialObjVal = DayNote(
                            initialObjVal.id,
                            initialObjVal.date,
                            newTitleValue,
                            initialObjVal.description);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 7),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextFormField(
                      initialValue: initialObjVal.description,
                      style: TextStyle(fontSize: 16),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What happend today? Write here.....'),
                      maxLines: 25,
                      validator: (descriptionValue) {
                        if (descriptionValue == '') {
                          return 'Please Provide some description!';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newDescriptionValue) {
                        initialObjVal = DayNote(
                            initialObjVal.id,
                            initialObjVal.date,
                            initialObjVal.title,
                            newDescriptionValue);
                      },
                    ),
                  )
                ],
              ))),
    );
  }
}
