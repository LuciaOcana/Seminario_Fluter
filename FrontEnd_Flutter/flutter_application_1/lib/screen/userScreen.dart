import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/controllers/userListController.dart';
import 'package:flutter_application_1/controllers/registerController.dart';
import 'package:flutter_application_1/Widgets/userCard.dart';
import 'package:get/get.dart';
import '../models/user.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<UserModel> _data = []; // Lista para almacenar los usuarios
  final UserService _userService = UserService();
  final RegisterController registerController = Get.put(RegisterController());
  final UserListController userController = Get.put(UserListController());

  bool _isLoading = false;
  String? _errorMessage;
  String? _usernameError;
  String? _mailError;
  String? _passwordError;
  String? _commentError;

  @override
  void initState() {
    super.initState();
    getUsers(); // Obtener la lista de usuarios al iniciar
  }

  Future<void> getUsers() async {
    final data = await _userService.getUsers();
    setState(() {
      _data = data; // Actualizamos la lista con los datos obtenidos
    });
  }

  // Función para eliminar un usuario
  Future<void> deleteUser(UserModel user) async {
    final response = await _userService.deleteUser(user.mail); // Usamos el correo para eliminar

    if (response == 201) {
      setState(() {
        _data.removeWhere((u) => u.mail == user.mail); // Eliminamos el usuario por correo
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario eliminado con éxito!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error desconocido al eliminar'),
        ),
      );
    }
  }

// Mostrar el cuadro de diálogo de edición del usuario
void _showEditDialog(UserModel user) async {
  final TextEditingController nameController = TextEditingController(text: user.name ?? '');
  final TextEditingController mailController = TextEditingController(text: user.mail ?? '');
  final TextEditingController commentController = TextEditingController(text: user.comment ?? '');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: mailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Comentario'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Preparar los datos del usuario en formato JSON
              final userData = {
                'name': nameController.text.trim(),
                'mail': mailController.text.trim(),
                'comment': commentController.text.trim(),
              };

              // Llamar a la función editUser del UserListController
              userController.editUser(userData);
              print("el usuario editado es $userData");

              Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
            },
            child: Text('Guardar'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Lista de usuarios
            Expanded(
              child: Obx(() {
                if (userController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (userController.userList.isEmpty) {
                  return Center(child: Text("No hay usuarios disponibles"));
                } else {
                  return ListView.builder(
                    itemCount: userController.userList.length,
                    itemBuilder: (context, index) {
                      return UserCard(
                        user: userController.userList[index],
                        onEdit: _showEditDialog, // Pasamos la función de edición
                      );
                    },
                  );
                }
              }),
            ),
            SizedBox(width: 20),
            // Formulario de registro de usuario
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crear Nuevo Usuario',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: registerController.nameController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      errorText: _usernameError, // Definir o eliminar estas variables
                    ),
                  ),
                  TextField(
                    controller: registerController.mailController,
                    decoration: InputDecoration(
                      labelText: 'Mail',
                      errorText: _mailError,
                    ),
                  ),
                  TextField(
                    controller: registerController.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      errorText: _passwordError,
                    ),
                    obscureText: true,
                  ),
                  TextField(
                    controller: registerController.commentController,
                    decoration: InputDecoration(
                      labelText: 'Comentario',
                      errorText: _commentError,
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(() {
                    if (registerController.isLoading.value) {
                      return CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                        onPressed: registerController.signUp,
                        child: Text('Registrarse'),
                      );
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
