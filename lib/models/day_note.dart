import 'package:flutter/cupertino.dart';

class DayNote {
  @required
  String? id;
  @required
  DateTime? date;
  @required
  String? title;
  @required
  String? description;
  DayNote(this.id, this.date, this.title, this.description);
}
