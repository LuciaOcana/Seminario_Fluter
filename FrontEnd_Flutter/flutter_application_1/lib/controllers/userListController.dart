import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/models/user.dart';

class UserListController extends GetxController {
  var isLoading = true.obs;
  var userList = <UserModel>[].obs;
  final UserService userService = UserService();

  // Controladores para los campos de edición
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  // Método para obtener los usuarios
  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      var users = await userService.getUsers();
      if (users != null) {
        userList.assignAll(users); // Asigna todos los usuarios a la lista reactiva
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
    }
  }

// Método para cargar los datos del usuario seleccionado en los controladores
void loadUserDataForEdit(UserModel user) {
  nameController.text = user.name?.trim() ?? '';
  mailController.text = user.mail?.trim() ?? '';
  passwordController.text = user.password?.trim() ?? '';
  commentController.text = user.comment?.trim() ?? '';
}

// Método para obtener los datos actualizados del usuario desde los controladores
Map<String, String> getUpdatedUserData() {
  return {
    'name': nameController.text.trim(),      // Nombre del usuario (puede estar vacío)
    'mail': mailController.text.trim(),      // Correo del usuario (el correo del usuario ya lo tenemos en el controlador)
    'comment': commentController.text.trim(), // Comentario del usuario (puede estar vacío)
  };
}

// Método para editar un usuario
Future<void> editUser(Map<String, String> userData) async {
  print("editando usuario");

  // Iniciar el proceso de edición
  isLoading.value = true;

  try {
    // Llamada al servicio para editar el usuario
    final responseData = await userService.editUser(
      userData['mail']!,  // Usamos el mail del usuario para buscarlo en la base de datos (asegurándonos de que no sea nulo)
      userData,           // Datos a actualizar (nombre, correo, comentario)
    );

    // Verificar la respuesta
    if (responseData == 201) {
      Get.snackbar('Éxito', 'Usuario actualizado con éxito');
      fetchUsers(); // Recargar los usuarios después de la edición
      Get.back(); // Regresar a la pantalla anterior
    } else {
      Get.snackbar('Error', 'No se pudo actualizar el usuario',
          snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    print("Error al editar el usuario: $e");
    Get.snackbar('Error', 'Error al editar el usuario: $e',
        snackPosition: SnackPosition.BOTTOM);
  } finally {
    isLoading.value = false;
  }
}

}
