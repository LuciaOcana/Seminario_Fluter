import 'package:flutter/material.dart';
import '../models/user.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final Function onEdit;

  const UserCard({Key? key, required this.user, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(user.mail),
            const SizedBox(height: 8),
            Text(user.comment ?? "Sin comentarios"),
            // Botón de edición en la esquina inferior derecha
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => onEdit(user), // Llamamos a la función pasada
              ),
            ),
          ],
        ),
      ),
    );
  }
}
