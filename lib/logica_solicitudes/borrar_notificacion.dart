import 'package:cloud_firestore/cloud_firestore.dart';

class BorrarNotificacion {
  Future<void> borrarNotificaciones(String idNotificacion) async {
    try {
      // Busca el documento que coincide con el atributo `idNotificacion`
      final querySnapshot = await FirebaseFirestore.instance
          .collection('notificaciones')
          .where('idNotificacion', isEqualTo: idNotificacion)
          .get();

      // Si se encuentra, elimina el documento
      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('notificaciones')
            .doc(doc.id)
            .delete();
      }
    } catch (e) {
      print('Error al borrar la notificación: $e');
      rethrow;
    }
  }
}
