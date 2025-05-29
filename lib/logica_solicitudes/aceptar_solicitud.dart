import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lfru_app/models/grupos_model.dart';
import 'package:lfru_app/models/user_mdel.dart';
import 'package:lfru_app/models/notificaciones_model.dart';

class AceptarSolicitud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void aceptarSolicitud(String idNotificacion, String correoUsuario, String idGrupo) async {
    try {
      // 1. Marcar la notificación como leída
      await _firestore.collection('notificaciones').doc(idNotificacion).update({
        'leida': true,
      });

      // 2. Obtener el usuario que envió la solicitud
      QuerySnapshot userSnapshot = await _firestore
          .collection('usuarios')
          .where('correo', isEqualTo: correoUsuario)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print('Usuario no encontrado');
        return;
      }

      // Usar el primer documento encontrado
      DocumentSnapshot userDoc = userSnapshot.docs.first;
      UserModel user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      // 3. Obtener el grupo usando where en lugar de doc(idGrupo)
      QuerySnapshot groupSnapshot = await _firestore
          .collection('grupos_estudio')
          .where('idGrupo', isEqualTo: idGrupo)
          .get();

      if (groupSnapshot.docs.isEmpty) {
        print('Grupo no encontrado');
        return;
      }

      // Usar el primer documento encontrado
      DocumentSnapshot groupDoc = groupSnapshot.docs.first;
      GruposModel group = GruposModel.fromMap(groupDoc.data() as Map<String, dynamic>);

      // 4. Añadir el grupo al usuario si no está ya en la lista
      if (!user.groups.any((g) => g.idGrupo == idGrupo)) {
        user.groups.add(group);
      }

      // Actualizar la lista de grupos del usuario en Firestore
      await _firestore.collection('usuarios').doc(userDoc.id).update({
        'groups': user.groups.map((group) => group.toMap()).toList(),
      });

      // 5. Verificar y disminuir el número de cupos del grupo
      if (group.cupos > 0) {
        group.cupos -= 1;
      } else {
        print('No hay cupos disponibles');
        return;
      }

      // Actualizar los datos del grupo en Firestore
      await _firestore.collection('grupos_estudio').doc(groupDoc.id).update({
        'cuposDisponibles': group.cupos,
        'miembros': FieldValue.arrayUnion([correoUsuario]),
      });

      // 6. Enviar una notificación al usuario
      final nuevaNotificacion = NotificacionesModel(
        idNotificacion: UniqueKey().toString(), // Firebase lo generará automáticamente
        origen: user.correo, // Cambia según sea necesario
        destino: correoUsuario,
        tipo: 'solicitud_aceptada',
        titulo: 'Solicitud aceptada',
        cuerpo: '¡Felicidades! Ahora eres miembro del grupo ${group.nombreGrupo}.',
        fecha: DateTime.now(),
        idRequerido: idGrupo,
      );

      await _firestore.collection('notificaciones').add(nuevaNotificacion.toJson());


      print('Solicitud aceptada, grupo añadido al usuario y notificación enviada');
    } catch (e) {
      print('Error al aceptar la solicitud: $e');
    }
  }
}
