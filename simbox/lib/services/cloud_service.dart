// import 'package:firebase_database/firebase_database.dart';

// class Database {
//   final db = FirebaseDatabase.instance.reference();

//   void writeData() {
//     try {
//       db.child("path").set({
//       'id':'asdasd',
//       'status': true
//     });
//     } catch (e) {
//       print(e);
//     }
//   }

//   void readData() {
//     try {
//       db.once().then((DataSnapshot dataSnapshot){
//         print(dataSnapshot.value);
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
  
//   void updateData() {
//     try {
//       db.child("path").update({
//       'id':'update',
//       'status': true
//     });
//     } catch (e) {
//       print(e);
//     }
//   }

//   void deleteData() {
//     try {
//       db.child('path').remove();
//     } catch (e) {
//       print(e);
//     }
//   }
  
// }