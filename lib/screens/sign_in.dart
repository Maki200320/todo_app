import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/components/text_field.dart';
import 'package:todo_app/services/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final key = GlobalKey<FormState>();
  final fbAuth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Form(
        key:  key,
        child: Column(
          children: [
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter email...",
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Cannot be empty...';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0,),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter password...",
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Cannot be empty...';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0,),
            ElevatedButton(onPressed: (){
              if(key.currentState!.validate()){
                fbAuth.signIn(email.text, password.text);
              }
            }, child: Text(
              "Login"
            ))
          ],
        ),

      )
    )


    );
  }
}
