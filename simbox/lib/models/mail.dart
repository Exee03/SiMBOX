import 'package:firebase_database/firebase_database.dart';

class Mail {
  int count;
  String uid;

  Mail({this.count, this.uid});

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(count: json['count'], uid: json['uid']);
  }
}

List<Mail> fromDb(DataSnapshot data) {
  List<Mail> itemList = new List();
  Map<String, dynamic> mapOfMaps = Map.from(data.value);
  mapOfMaps.values.forEach((value) {
    itemList.add(Mail.fromJson(Map.from(value)));
  });
  return itemList;
}