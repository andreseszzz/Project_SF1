import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/user_mdel.dart';

class GruposModel {
  final UserModel propietario;
  final String nombreGrupo;
  String? idGrupo;
  final String descripcionGrupo;
  int cupos;
  final String facultad;
  final String carrera;
  final String escuela;
  final String materia;
  final String tema;
  final DateTime fecha;
  final bool tutor;

  GruposModel({
    required this.propietario,
    required this.nombreGrupo,
    required this.idGrupo,
    required this.descripcionGrupo,
    required this.cupos,
    required this.facultad,
    required this.carrera,
    required this.escuela,
    required this.fecha,
    required this.materia,
    required this.tema,
    required this.tutor,
  });

  factory GruposModel.fromMap(Map<String, dynamic> data) {
    return GruposModel(
      propietario: UserModel.fromMap(data['propietario']),
      nombreGrupo: data['nombre_grupo'] ?? 'Grupo nuevo',
      idGrupo: data['idGrupo'] ?? '',
      descripcionGrupo: data['descripcion_grupo'] ?? 'Descripcion del grupo',
      cupos: data['cupos'] ?? 3, 
      facultad: data['facultad'] ?? 'Facultad',
      carrera: data['carrera'] ?? 'Carrera',
      escuela: data['escuela'] ?? 'Escuela',
      materia: data['materia'] ?? 'Materia',
      tema: data['tema'] ?? 'Tema',
      fecha: (data['fecha'] as Timestamp).toDate(),
      tutor: data['tutor'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'propietario': propietario.toMap(),
      'nombre_grupo': nombreGrupo,
      'idGrupo': idGrupo,
      'descripcion_grupo': descripcionGrupo,
      'cupos': cupos,
      'facultad': facultad,
      'carrera': carrera,
      'escuela': escuela,
      'materia': materia,
      'tema': tema,
      'fecha': fecha,
      'tutor': tutor,
    };
  }
}