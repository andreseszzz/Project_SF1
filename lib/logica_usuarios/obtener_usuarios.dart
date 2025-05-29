import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/user_mdel.dart';

class ObtenerUsuario {
  static Future<UserModel?> obtenerUsuarioPorCorreo(String correo) async {
    try {
      // Buscar el usuario por correo
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: correo)
          .get();

      // Verificar si hay documentos encontrados
      if (snapshot.docs.isNotEmpty) {
        // Obtener el primer documento
        DocumentSnapshot userDoc = snapshot.docs.first;
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }

      // Si no se encuentra el usuario, devolver null
      print('Usuario no encontrado');
      return null;
    } catch (e) {
      print('Error al obtener usuario: $e');
      return null;
    }
  }
}
