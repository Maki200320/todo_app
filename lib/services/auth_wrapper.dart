import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/sign_in.dart';
import 'package:todo_app/screens/sign_up.dart';
import 'package:todo_app/screens/todo_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          else if(snapshot.hasData && snapshot.data != null){
            return const TodoScreen();
          }
          else{
            return const SignIn();
          }
        }
    );
  }

}
