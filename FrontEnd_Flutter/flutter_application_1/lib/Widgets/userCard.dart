import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/userModel.dart'; // Ajusta la ruta si tu modelo está en otra carpeta
import '../services/user.dart';
import '../controllers/userListController.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  // Método para eliminar usuario
  void _deleteUser(BuildContext context, String userId) async {
    final userService = UserService();
    final UserListController userListController = Get.put(UserListController());

    try {
      int statusCode = await userService.deleteUser(userId);
      if (statusCode == 200 || statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario eliminado con éxito.'), backgroundColor: Colors.green),
        );
        await userListController.fetchUsers(); // Refrescar lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el usuario.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Método para editar usuario
  void _editUser(BuildContext context) {
    final nameController = TextEditingController(text: user.name);
    final mailController = TextEditingController(text: user.mail);
    final commentController = TextEditingController(text: user.comment ?? "");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: mailController,
                  decoration: InputDecoration(labelText: 'Correo'),
                ),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(labelText: 'Comentario'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userService = UserService();
                final UserListController userListController = Get.put(UserListController());

                // Datos actualizados
                UserModel updatedUser = new UserModel(id: user.id ,name: nameController.text, mail: mailController.text, password: user.password, comment: commentController.text);

                try {
                  // Llamar al servicio de actualización
                  int statusCode = await userService.EditUser(updatedUser, user.id!);
                  await userListController.fetchUsers(); // Refrescar lista

                  /*if (statusCode == 200 || statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario actualizado correctamente.'), backgroundColor: Colors.green),
                    );
                    await userListController.fetchUsers(); // Refrescar lista
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al actualizar el usuario.'), backgroundColor: Colors.red),
                    );
                  }*/
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }

                Navigator.of(context).pop(); // Cerrar el diálogo
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user.mail),
            const SizedBox(height: 8),
            Text(user.comment ?? "Sin comentarios"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _editUser(context), // Botón Editar
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Editar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _deleteUser(context, user.id!), // Botón Borrar
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Borrar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
