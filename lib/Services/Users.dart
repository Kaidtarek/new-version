import 'package:firebase_auth/firebase_auth.dart';

class Users {
  Users(this.email, this.pwd);
  String email, pwd;

  Future<String> login() async {
    try {
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'succes'; 
  }
}
