import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/user.dart';

class FirebaseAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore cloudFire = FirebaseFirestore.instance;

  Future<void> signIn(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = credential.user;
      if (firebaseUser != null) {
        String? userEmail = firebaseUser.email;
        String userId = firebaseUser.uid;

        if (userEmail != null) {
          CurrUser user = CurrUser(id: userId, email: userEmail);

          // Store the user in Firestore
          await cloudFire.collection('users').doc(user.id).set(user.toJson());

          print('User signed in and email stored in Firestore: $userEmail');
        } else {
          print('User email is null');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email...');
      } else if (e.code == 'wrong-password') {
        print('Entered a wrong password...');
      } else {
        print('FirebaseAuthException during sign in: ${e.code}');
      }
    } catch (e) {
      print('An error occurred during sign in: $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = credential.user;
      if (firebaseUser != null) {
        print('User signed up: ${firebaseUser.email}');
        print('User UID: ${firebaseUser.uid}');

        String? userEmail = firebaseUser.email;
        String userId = firebaseUser.uid;

        if (userEmail != null) {
          CurrUser user = CurrUser(id: userId, email: userEmail);

          // Store the user in Firestore
          await cloudFire.collection('users').doc(user.id).set(user.toJson());

          print('User signed up and data stored in Firestore: $userEmail');
        } else {
          print('User email is null');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password is weak...');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exists for this email.');
      } else {
        print('FirebaseAuthException during sign up: ${e.code}');
      }
    } catch (e) {
      print('An error occurred during sign up: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      print('Sign out successful...');
    } catch (e) {
      print('An error occurred during sign out: $e');
    }
  }



  Future<CurrUser?> getCurrentUser() async {
    final _db = FirebaseFirestore.instance;
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      DocumentSnapshot doc = await _db.collection('users').doc(firebaseUser.uid).get();

      if (doc.exists) {
        return CurrUser.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        // Document does not exist
        return null;
      }
    } else {
      // No user is currently signed in
      return null;
    }
  }
}
