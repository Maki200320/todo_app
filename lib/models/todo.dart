import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  String description;
  final Timestamp createdAt;
  bool isDone;

  Todo({
    required this.id,
    required this.description,
    required this.createdAt,
    this.isDone = false, // Default to not done
  });

  // Convert Todo to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'createdAt': createdAt,
      'isDone': isDone,
    };
  }

  // Convert Firestore document to Todo
  factory Todo.fromJson(Map<String, dynamic> json, String id) {
    return Todo(
      id: id,
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      isDone: json['isDone'] ?? false,
    );
  }
}
