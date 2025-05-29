import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/notificaciones_model.dart';

class ObtenerNotificaciones {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NotificacionesModel>> obtenerNotificaciones(String idUsuarioDestino) async {
    try {
      // Consultar las notificaciones en Firestore donde el destino coincide con el usuario actual
      QuerySnapshot snapshot = await _firestore
          .collection('notificaciones')
          .where('destino', isEqualTo: idUsuarioDestino)
          .get();

      // Mapear los documentos a una lista de objetos NotificacionesModel
      List<NotificacionesModel> notificaciones = snapshot.docs.map((doc) {
        return NotificacionesModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return notificaciones;
    } catch (e) {
      // Manejo de errores
      print('Error al obtener las notificaciones: $e');
      return [];
    }
  }
}
