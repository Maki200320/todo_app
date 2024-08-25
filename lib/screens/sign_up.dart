import 'package:flutter/material.dart';
import 'package:todo_app/components/text_field.dart';

import '../services/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignInState();
}

class _SignInState extends State<SignUp> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final key = GlobalKey<FormState>();
  final fbAuth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
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

                },
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(onPressed: (){
                if(key.currentState!.validate()){
                  fbAuth.signUp(email.text, password.text);


                }
              }, child: Text(
                  "Sign Up"
              ))
            ],
          ),

        )
    )
    );
  }
}
