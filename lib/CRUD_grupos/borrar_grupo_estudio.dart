import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/models/grupos_model.dart';
import 'package:lfru_app/models/user_mdel.dart';

class GruposCRUD {
  // Método para eliminar un grupo
  static Future<void> borrarGrupo(
      UserModel? usuarioActual, GruposModel grupo) async {

    try {
      // Elimina el grupo desde Firestore (colección 'grupos_estudio')
      await FirebaseFirestore.instance
          .collection('grupos_estudio')
          .doc(grupo.idGrupo)
          .delete();

      // Elimina el grupo de la lista 'groups' del usuario
      if (usuarioActual != null) {
        // Usamos FieldValue.arrayRemove para eliminar el grupo de la lista
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(FirebaseAuth.instance.currentUser?.uid)  // Usamos el correo del usuario como ID
            .update({
          'groups': FieldValue.arrayRemove([grupo.toMap()]),
        });
      }
    } catch (e) {
      throw Exception('Error al borrar ${grupo.idGrupo} el grupo: $e');
    }
  }
}
