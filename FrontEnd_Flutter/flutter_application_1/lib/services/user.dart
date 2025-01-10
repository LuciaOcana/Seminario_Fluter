import 'dart:convert';
import 'package:flutter_application_1/models/user.dart';
import 'package:dio/dio.dart';

class UserService {
  final String baseUrl = "http://147.83.7.155:3000"; //URL docker
  //final String baseUrl = "http://127.0.0.1:3000"; // URL de tu backend Web
  //final String baseUrl = "http://10.0.2.2:3000"; // URL de tu backend Android
  final Dio dio = Dio(); // Usa el prefijo 'Dio' para referenciar la clase Dio
  var statusCode;
  var data;

  // Función createUser
  Future<int> createUser(UserModel newUser) async {
    print('createUser');
    print('try');
    // Aquí llamamos a la función request
    print('request');
    // Utilizar Dio para enviar la solicitud POST a http://127.0.0.1:3000/user
    Response response =
        await dio.post('$baseUrl/user/newUser', data: newUser.toJson());
    print('response');
    // En response guardamos lo que recibimos como respuesta
    // Printeamos los datos recibidos

    data = response.data.toString();
    print('Data: $data');
    // Printeamos el status code recibido por el backend

    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 200) {
      // Si el usuario se crea correctamente, retornamos el código 201
      print('200');
      return 201;
    } else if (statusCode == 400) {
      // Si hay campos faltantes, retornamos el código 400
      print('400');

      return 400;
    } else if (statusCode == 500) {
      // Si hay un error interno del servidor, retornamos el código 500
      print('500');

      return 500;
    } else {
      // Otro caso no manejado
      print('-1');

      return -1;
    }
  }

  // Obtener todos los usuarios
  Future<List<UserModel>> getUsers() async {
    print('getUsers');
    try {
      var res = await dio.get('$baseUrl/user');
      List<dynamic> responseData =
          res.data; // Obtener los datos de la respuesta

      // Convertir los datos en una lista de objetos UserModel
      List<UserModel> users =
          responseData.map((data) => UserModel.fromJson(data)).toList();

      return users; // Devolver la lista de usuarios
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud
      print('Error fetching data: $e');
      throw e; // Relanzar el error para que el llamador pueda manejarlo
    }
  }

// En el servicio, el método editUser espera el email y los datos a actualizar
Future<int> editUser(String email, Map<String, String> updatedUserData) async {
  print('editUser');
  print('Intentando actualizar usuario con correo: $email');

  try {
    // Realizamos la solicitud PUT para actualizar al usuario
    Response response = await dio.put(
      '$baseUrl/user/updateByMail/$email', // URL con el correo del usuario
      data: updatedUserData, // Enviamos los datos que se desean actualizar (name, mail, comment)
    );

    // Imprimimos los datos de la respuesta
    data = response.data.toString();
    print('Data: $data');

    // Código de estado de la respuesta
    statusCode = response.statusCode;
    print('Status code: $statusCode');

    // Analizamos la respuesta según el status code
    if (statusCode == 200) {
      print('Usuario actualizado correctamente');
      return 200; // Si la actualización es exitosa
    } else if (statusCode == 400) {
      print('Error: Datos inválidos');
      return 400; // Si el servidor devuelve un error por datos incorrectos
    } else if (statusCode == 500) {
      print('Error interno en el servidor');
      return 500; // Si hay un error en el servidor
    } else {
      print('Error desconocido');
      return -1; // Otro error no manejado
    }
  } catch (e) {
    // Si ocurre un error en la solicitud, lo manejamos aquí
    print('Error al realizar la solicitud de actualización: $e');
    return -1; // Error desconocido
  }
}


  // Función para eliminar un usuario
  Future<int> deleteUser(String email) async {
    print('deleteUser');
    print('try');
    // Aquí llamamos a la función request
    print('request');
    
    // Utilizar Dio para enviar la solicitud DELETE a http://127.0.0.1:3000/user/{email}
    Response response = await dio.delete('$baseUrl/user/$email'); // Usamos el correo electrónico en lugar del ID

    // En response guardamos lo que recibimos como respuesta
    // Printeamos los datos recibidos
    data = response.data.toString();
    print('Data: $data');
    // Printeamos el status code recibido por el backend
    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 200) {
      // Si el usuario se elimina correctamente, retornamos el código 200
      print('200');
      return 200;
    } else if (statusCode == 400) {
      // Si hay campos faltantes, retornamos el código 400
      print('400');
      return 400;
    } else if (statusCode == 500) {
      // Si hay un error interno del servidor, retornamos el código 500
      print('500');
      return 500;
    } else {
      // Otro caso no manejado
      print('-1');
      return -1;
    }
  }

  // Función de login
  Future<int> logIn(logIn) async {
    print('LogIn');
    print('try');
    // Aquí llamamos a la función request
    print('request');

    print('el login es:${logIn}');

    Response response =
        await dio.post('$baseUrl/user/logIn', data: logInToJson(logIn));
    // En response guardamos lo que recibimos como respuesta
    // Printeamos los datos recibidos

    data = response.data.toString();
    print('Data: $data');
    // Printeamos el status code recibido por el backend

    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 200) {
      print('200');
      return 201;
    } else if (statusCode == 400) {
      // Si hay campos faltantes, retornamos el código 400
      print('400');

      return 400;
    } else if (statusCode == 500) {
      // Si hay un error interno del servidor, retornamos el código 500
      print('500');

      return 500;
    } else {
      // Otro caso no manejado
      print('-1');

      return -1;
    }
  }

  // Convertir logIn a JSON
  Map<String, dynamic> logInToJson(logIn) {
    return {'mail': logIn.mail, 'password': logIn.password};
  }
}
