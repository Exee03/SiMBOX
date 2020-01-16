import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseMessaging _messaging = FirebaseMessaging();

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    userUpdateInfo.photoUrl =
        'https://www.theatricalrights.com/wp-content/themes/trw/assets/images/default-user.png';
    await currentUser.user.updateProfile(userUpdateInfo);
    await currentUser.user.reload();
    updateUserData(currentUser.user);
    return currentUser.user.uid;
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    final currentUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (currentUser.user.photoUrl == null) {
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.photoUrl =
          'https://www.theatricalrights.com/wp-content/themes/trw/assets/images/default-user.png';
      await currentUser.user.updateProfile(userUpdateInfo);
      await currentUser.user.reload();
    }
    updateUserData(currentUser.user);
    return currentUser.user.uid;
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    print(user.photoUrl);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    updateUserData(currentUser);
    googleSignIn.disconnect();

    return currentUser.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return _firebaseAuth.currentUser();
  }

  signOut() {
    return _firebaseAuth.signOut();
  }

  void updateUserData(FirebaseUser user) async {
    final String token = await _messaging.getToken();
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'photoUrl': user.photoUrl,
      'token': token
    }, merge: true);
  }
}
