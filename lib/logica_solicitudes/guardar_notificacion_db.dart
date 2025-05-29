import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/notificaciones_model.dart';

class GuardarNotificacionDb {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> guardarNotificacion(NotificacionesModel notificacion) async {
    try {
      await _firestore.collection('notificaciones').doc(notificacion.idNotificacion).set(notificacion.toJson());
    } catch (e) {
      // ignore: avoid_print
      print("Error al guardar la notificación: $e");
    }
  }
}
