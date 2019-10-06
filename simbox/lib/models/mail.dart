import 'package:firebase_database/firebase_database.dart';

class Mail {
  int count;
  String time;
  String date;

  Mail({this.count, this.time, this.date});

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(count: json['count'], time: json['time'], date: json['date']);
  }
}

List<Mail> fromDb(DataSnapshot data) {
  List<Mail> companyList = new List();
  Map<String, dynamic> mapOfMaps = Map.from(data.value);
  mapOfMaps.values.forEach((value) {
    companyList.add(Mail.fromJson(Map.from(value)));
  });
  return companyList;
}