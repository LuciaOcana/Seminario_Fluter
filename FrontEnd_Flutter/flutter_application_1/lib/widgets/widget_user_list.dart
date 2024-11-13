// widget_user_list.dart
import 'package:flutter/material.dart';

// Definición del modelo User
class User {
  final String name;
  final String email;
  final String comment;

  User({required this.name, required this.email, required this.comment});

  // Método para crear un objeto User desde un Map (decodificación JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['mail'] as String, // Asegúrate que coincide con tu JSON
      comment: json['comment'] as String,
    );
  }
}

// Widget personalizado para la lista de usuarios
class UserListWidget extends StatelessWidget {
  final List<User> users;

  const UserListWidget({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text(user.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user.email}'),
                SizedBox(height: 5),
                Text('Comentario: ${user.comment}'),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
