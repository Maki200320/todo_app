import 'package:todo_app/models/todo.dart';

class CurrUser {
  final String id;
  final String email;


  CurrUser({required this.id, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,

    };
  }

  factory CurrUser.fromJson(Map<String, dynamic> json) {
    return CurrUser(
      id: json['id'],
      email: json['email'],

    );
  }
}
