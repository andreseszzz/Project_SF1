import 'carrera.dart';

class Facultad {
  final String id;
  final String nombreFacultad;
  final List<Carrera> carreras;

  Facultad({required this.id, required this.nombreFacultad, required this.carreras});

  factory Facultad.fromMap(Map<String, dynamic> data) {
    return Facultad(
      id: data['id'] ?? '', // Proporciona un valor predeterminado si falta
      nombreFacultad: data['nombreFacultad'] ?? 'Nombre no especificado',
      carreras: (data['carreras'] as List<dynamic>? ?? [])
          .map((carreraData) => Carrera.fromMap(carreraData))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreFacultad': nombreFacultad,
      'carreras': carreras.map((carrera) => carrera.toMap()).toList(),
    };
  }

  Facultad copyWith({String? id, String? nombreFacultad, List<Carrera>? carreras}){

    return Facultad(
      id:id?? this.id,
      nombreFacultad: nombreFacultad?? this.nombreFacultad,
      carreras: carreras?? this.carreras,
      );
  }
}
