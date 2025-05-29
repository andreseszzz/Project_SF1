import 'package:cloud_firestore/cloud_firestore.dart';

class NotificacionesModel {
  final String idNotificacion; // ID único de la notificación
  final String origen; // ID del usuario que genera la notificación
  final String destino; // ID del usuario que recibe la notificación
  final String tipo; 
  final String titulo; 
  final String cuerpo; 
  final DateTime fecha; 
  final bool leida;
  final idRequerido;

  NotificacionesModel({
    required this.idNotificacion,
    required this.origen,
    required this.destino,
    required this.tipo,
    required this.titulo,
    required this.cuerpo,
    required this.fecha,
    this.leida = false,
    required this.idRequerido,
  });

  // Método para convertir a JSON (útil si trabajas con Firebase o APIs)
  Map<String, dynamic> toJson() {
    return {
      'idNotificacion': idNotificacion,
      'origen': origen,
      'destino': destino,
      'tipo': tipo,
      'titulo': titulo,
      'cuerpo': cuerpo,
      'fecha': fecha,
      'leida': leida,
      'idRequerido':idRequerido,
    };
  }

  // Método para construir desde JSON
  factory NotificacionesModel.fromJson(Map<String, dynamic> json) {
    return NotificacionesModel(
      idNotificacion: json['idNotificacion'],
      origen: json['origen'],
      destino: json['destino'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      cuerpo: json['cuerpo'],
      fecha: (json['fecha'] as Timestamp).toDate(),
      leida: json['leida'],
      idRequerido: json['idRequerido'],
    );
  }


}
