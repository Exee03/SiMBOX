import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
    (FirebaseUser user) => user?.uid,
  );

  Future<String> createUserWithEmailAndPassword(String email, String password, String name) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    userUpdateInfo.photoUrl = 'https://www.theatricalrights.com/wp-content/themes/trw/assets/images/default-user.png';
    await currentUser.user.updateProfile(userUpdateInfo);
    await currentUser.user.reload();
    updateUserData(currentUser.user);
    return currentUser.user.uid;
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    final currentUser = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    updateUserData(currentUser.user);
    return currentUser.user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser userInfo = await _firebaseAuth.currentUser();
    return userInfo;
  }

  signOut() {
    return _firebaseAuth.signOut();
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'photoUrl': user.photoUrl
    }, merge: true);
  }
}