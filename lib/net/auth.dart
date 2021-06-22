import 'package:firebase_auth/firebase_auth.dart';
import 'package:jamal_v1/net/database.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> register(String email, String password, String name, String age,
      String height, String weight, String fitnessLevel) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      User user = result.user;

      // create default values for now
      await DatabaseService(uid: user.uid).updateUserData(
          email, password, name, age, height, weight, fitnessLevel);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      print('1');
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print('2');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      }
    }
    return false;
  }

  Future<bool> anon() async {
    try {
      await _auth.signInAnonymously();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  // get user UID
  Future<String> getCurrentID() async {
    return (await _auth.currentUser).uid;
  }

  // get user UID
  User getCurrentUser() {
    //return firebase.auth().currentUser;
    return _auth.currentUser;
  }
}
