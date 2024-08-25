  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
  import 'package:todo_app/models/todo.dart';

  class TodoFunctions{

  final FirebaseFirestore _db = FirebaseFirestore.instance;



    //create_todo
  Future<void> createTodo(Todo todo) async {
    try {
      // Get the current user
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        await _db
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('todos')
            .add(todo.toJson());
        print("Todo Added $todo SUCCESSFULLY");
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> toggleTodoDone(Todo todo)async{
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('todos')
          .doc(todo.id)
          .update({'isDone': !todo.isDone});
    }
  }
  Future updateTodo(Todo todo)async{
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('todos')
          .doc(todo.id)
          .update({'description': todo.description});
    }
  }




  Stream<List<Todo>> getTodosStream() {
    // Get the current user
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Return a stream of todos for the current user
      return FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('todos')
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Todo.fromJson(doc.data(), doc.id))
          .toList());
    } else {
      // Return an empty stream if no user is logged in
      return Stream.value([]);
    }
  }

  Future<void> deleteTodo(String id)async{
//get curr user
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if(firebaseUser != null){
      _db.collection('users')
      .doc(firebaseUser.uid)
          .collection('todos')
          .doc(id)
          .delete()
          .then((doc) => print("Document $id is deleted"),
      onError: (e){
            print("Error in deleting $e ");
      }
      );
    }
  }


  }