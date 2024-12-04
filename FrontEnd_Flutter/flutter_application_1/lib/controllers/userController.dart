import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/models/user.dart';  // Asegúrate de importar el modelo User

class UserController extends GetxController {
  final UserService userService = Get.put(UserService());

  // Controladores de texto para los campos a editar
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  // Variables reactivas para la UI
  var isLoading = false.obs;
  var errorMessage = ''.obs;

void editUser(String userEmail) async {
  // Iniciar el proceso de edición
  isLoading.value = true;
  errorMessage.value = ''; // Limpiamos el mensaje de error

  // Crear un mapa con los datos a enviar al backend
  final updatedUserData = {
    'name': nameController.text,      // Nombre del usuario (puede estar vacío)
    'mail': mailController.text,      // Correo del usuario (se utiliza para identificar al usuario)
    'comment': commentController.text, // Comentario del usuario (puede estar vacío)
  };

  try {
    // Llamada al servicio para editar el usuario
    final responseData = await userService.editUser(userEmail, updatedUserData);

    // Manejo de la respuesta del backend
    if (responseData == 200) {  // Si la respuesta es 200, la actualización fue exitosa
      Get.snackbar('Éxito', 'Usuario actualizado con éxito');
      // Puedes redirigir a otra página si es necesario, por ejemplo:
      Get.back(); // Regresa a la pantalla anterior
    } else {
      errorMessage.value = 'No se pudo actualizar el usuario'; // Mensaje de error si la respuesta es diferente
    }
  } catch (e) {
    errorMessage.value = 'Error: No se pudo conectar con la API'; // Error si hay problema con la conexión
  } finally {
    isLoading.value = false; // Detener el indicador de carga
  }
}

  // Función de login (mantenida para referencia)
  void logIn() async {
    // Validación de campos
    if (mailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Campos vacíos',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validación de formato de correo electrónico
    if (!GetUtils.isEmail(mailController.text)) {
      Get.snackbar('Error', 'Correo electrónico no válido',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    print('estoy en el login de usercontroller');

    final logIn = (
      mail: mailController.text,
      password: passwordController.text,
    );

    // Iniciar el proceso de inicio de sesión
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Llamada al servicio para iniciar sesión
      final responseData = await userService.logIn(logIn);

      print('el response data es:${ responseData}');

      if (responseData != null) {
        // Manejo de respuesta exitosa
        Get.snackbar('Éxito', 'Inicio de sesión exitoso');
        Get.toNamed('/home');
      } else {
        errorMessage.value = 'Usuario o contraseña incorrectos';
      }
    } catch (e) {
      errorMessage.value = 'Error: No se pudo conectar con la API';
    } finally {
      isLoading.value = false;
    }
  }
}
