import 'package:flutter/material.dart';
import 'package:lfru_app/logica_solicitudes/guardar_notificacion_db.dart';
import 'package:lfru_app/models/notificaciones_model.dart';

class RechazarSolicitud {

  // Rechazar solicitud
  static void rechazarSolicitud(String idNotificacion, String idUsuarioDestino, String idUsuarioOrigen, String idGrupo) async {
    try {
      // 1. Enviar notificación de rechazo al usuario
      final notificacionRechazo = NotificacionesModel(
        idNotificacion: UniqueKey().toString(),
        origen: idUsuarioOrigen,
        destino: idUsuarioDestino,
        tipo: 'solicitud_rechazada',
        titulo: 'Solicitud rechazada',
        cuerpo: 'Lamentablemente, tu solicitud para unirte al grupo ha sido rechazada.',
        fecha: DateTime.now(),
        idRequerido: idGrupo,
      );
      // guardamos la notificación para que el otro ususario la vea
      GuardarNotificacionDb.guardarNotificacion(notificacionRechazo);
      print('Solicitud rechazada y notificación enviada al usuario');
    } catch (e) {
      print('Error al rechazar la solicitud: $e');
    }
  }
}
