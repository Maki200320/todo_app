import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/todo_functions.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final FirebaseAuthService firebaseAuthRef = FirebaseAuthService();
  final TodoFunctions todoFunctions = TodoFunctions();
  final TextEditingController description = TextEditingController();
  CurrUser? userEmail;


  @override
  void initState() {
    // TODO: implement initState
    getUsername();
    super.initState();
  }
  String _formatEmail(String email) {
    // Split the email at '@' and capitalize the first letter
    final parts = email.split('@');
    if (parts.isEmpty) return '';

    final localPart = parts[0];
    final capitalizedEmail = localPart.isNotEmpty
        ? localPart[0].toUpperCase() + localPart.substring(1).toLowerCase()
        : '';

    return capitalizedEmail;
  }

  Future getUsername()async{
    CurrUser? userData = await firebaseAuthRef.getCurrentUser();
    setState(() {
      userEmail = userData;
    });
  }

  void _addTodo() {
    String descriptionNoSpace = description.text.trim();
    if (descriptionNoSpace.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Description cannot be empty or only spaces.")),
      );
    } else {
      final desc = description.text;
      Todo todo = Todo(
        id: '',
        description: desc,
        createdAt: Timestamp.now(),
      );

      todoFunctions.createTodo(todo).then((_) {
        // Clear the text field
        description.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Todo added successfully.")),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding todo: $error")),
        );
      });
    }
  }
  void _showEditDialog(Todo todo) {
    TextEditingController _editController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  todo.description = _editController.text;
                });
                todoFunctions.updateTodo(todo).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Todo updated successfully.")),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error updating todo: $error")),
                  );
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                firebaseAuthRef.signOut().then((_) {
                  Navigator.of(context).pop(); // Navigate back on sign out
                });
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            children: [
              userEmail != null
                  ?  Align(
                alignment: Alignment.centerLeft, // Aligns the Text widget to the start
                child: Text(
                  _formatEmail(userEmail!.email),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              TextField(
                controller: description,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Enter your todo description...",
                ),
                onSubmitted: (_) => _addTodo(), // Optional: add todo on enter key press
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addTodo,
                child: const Text("Add Todo"),
              ),
              Expanded(
                child: StreamBuilder<List<Todo>>(
                  stream: todoFunctions.getTodosStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No todos found.'));
                    } else {
                      final todos = snapshot.data!;
                      final activeTodos = todos.where((todo) => !todo.isDone).toList();
                      final doneTodos = todos.where((todo) => todo.isDone).toList();

                      return Column(
                        children: [
                          Expanded(

                            child: ListView.builder(
                              itemCount: activeTodos.length,
                              itemBuilder: (context, index) {
                                final todo = activeTodos[index];
                                return ListTile(
                                  onTap: (){
                                    _showEditDialog(todo);

                                  },
                                  leading: Checkbox(
                                    value: todo.isDone,
                                    onChanged: (value) {
                                      todoFunctions.toggleTodoDone(todo);
                                    },
                                  ),
                                  title: Text(todo.description),
                                  subtitle: Text(todo.createdAt.toDate().toString()),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      todoFunctions.deleteTodo(todo.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          if (doneTodos.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Completed Todos"),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: doneTodos.length,
                              itemBuilder: (context, index) {
                                final todo = doneTodos[index];
                                return ListTile(
                                  leading: Checkbox(
                                    value: todo.isDone,
                                    onChanged: (value) {
                                      todoFunctions.toggleTodoDone(todo);
                                    },
                                  ),
                                  title: Text(todo.description,
                                      style: TextStyle(
                                          decoration: TextDecoration.lineThrough)),
                                  subtitle: Text(todo.createdAt.toDate().toString()),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      todoFunctions.deleteTodo(todo.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
