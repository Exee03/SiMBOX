// import 'package:firebase_database/firebase_database.dart';

// class Door {
//   int count;
//   String time;
//   String date;

//   Door({this.count, this.time, this.date});

//   factory Door.fromJson(Map<String, dynamic> json) {
//     return Door(count: json['count'], time: json['time'], date: json['date']);
//   }
// }

// List<Door> fromDb(DataSnapshot data) {
//   List<Door> companyList = new List();
//   Map<String, dynamic> mapOfMaps = Map.from(data.value);
//   mapOfMaps.values.forEach((value) {
//     companyList.add(Door.fromJson(Map.from(value)));
//   });
//   return companyList;
// }
