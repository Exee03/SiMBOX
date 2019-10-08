import 'package:firebase_database/firebase_database.dart';

class Door {
  String status;
  String uid;

  Door({this.status, this.uid});

  factory Door.fromJson(Map<String, dynamic> json) {
    return Door(status: json['status'], uid: json['uid']);
  }
}

String getStatusDoor(DataSnapshot data, String uid) {
  List<Door> itemList = new List();
  Map<String, dynamic> mapOfMaps = Map.from(data.value);
  mapOfMaps.values.forEach((value) {
    itemList.add(Door.fromJson(Map.from(value)));
  });
  String status = 'Unknown';
  itemList.forEach((e)=>{
    if(e.uid == uid) {
      status = e.status
    }
  });
  return status;
}