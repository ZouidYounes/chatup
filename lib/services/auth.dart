
import 'package:chatup/helper/helperfunctions.dart';
import 'package:chatup/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    try{
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }
}