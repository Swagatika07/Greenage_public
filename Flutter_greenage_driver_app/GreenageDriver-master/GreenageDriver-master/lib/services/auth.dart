// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Stream<User> get authSignInorSignOutStream {
//     return _auth.authStateChanges();
//   }
//
//   Future<UserCredential?> signInWithEmailAndPAssword(
//       String email, String password) async {
// print(email);
// print(password);
// print("on auth function......");
//     try {
//       UserCredential results = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return results;
//     } catch (e) {
//       print('Error occured in  appp $e');
//       return null;
//     }
//   }
//
//   Future<UserCredential?> registerWithEmailAndPAssword(
//       String email, String password) async {
//     try {
//       UserCredential results = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return results;
//     } catch (e) {
//       print('Error occured in Qbank appp $e');
//       return null;
//     }
//   }
//
//   Future<void> signOUt() async {
//     await _auth.signOut();
//   }
//
//   Future<dynamic> resetPassword(String email) async {
//     try {
//     await _auth.sendPasswordResetEmail(email: email);
// return "success";
//     }catch(e){
//
//       print(e.toString());
//       return null;
//     }
//
//     }
//
//
//
// }