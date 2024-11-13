// user.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/widgets/widget_user_list.dart'; // Importa tu nuevo widget

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Llamamos a la función para obtener datos cuando la página se carga
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/user')); // Cambia el puerto y la ruta según tu configuración

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON y crea una lista de User
        setState(() {
          final List<dynamic> data = json.decode(response.body);
          _users = data.map((item) => User.fromJson(item)).toList();
        });
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuarios')),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : UserListWidget(users: _users), // Usando el nuevo widget
    );
  }
}
