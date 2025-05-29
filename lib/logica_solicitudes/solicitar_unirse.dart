import 'package:flutter/material.dart';
import 'package:lfru_app/logica_solicitudes/guardar_notificacion_db.dart';
import 'package:lfru_app/models/notificaciones_model.dart';
import 'package:lfru_app/logica_usuarios/obtener_usuarios.dart';

class SolicitarUnirse {
  static Future<void> solicitarUnirse(
      String idUsuarioOrigen, String idGrupo, String idPropietarioGrupo,String nombreGrupo) async {
    try {
      // Obtener el usuario por su ID (correo)
      final usuarioOrigen = await ObtenerUsuario.obtenerUsuarioPorCorreo(idUsuarioOrigen);

      // Si el usuario no se encuentra, usa un nombre genérico.
      final nombreUsuario = usuarioOrigen?.name;

      final nuevaNotificacion = NotificacionesModel(
        idNotificacion: UniqueKey().toString(), // Genera un ID único
        origen: idUsuarioOrigen,
        destino: idPropietarioGrupo,
        tipo: 'solicitud_grupo',
        titulo: 'Nueva solicitud para tu grupo',
        cuerpo: 'El usuario $nombreUsuario desea unirse al grupo $nombreGrupo.',
        fecha: DateTime.now(),
        leida: false,
        idRequerido: idGrupo,
      );

      // Guardar la notificación en la base de datos
      await GuardarNotificacionDb.guardarNotificacion(nuevaNotificacion);
    } catch (e) {
      print('Error al solicitar unirse: $e');
    }
  }
}