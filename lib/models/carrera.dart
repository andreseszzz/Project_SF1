import 'escuela.dart';

class Carrera {
  final String id;
  final String nombreCarrera;
  final List<Escuela> escuelas;

  Carrera({required this.id, required this.nombreCarrera, required this.escuelas});

  factory Carrera.fromMap(Map<String, dynamic> data) {
    return Carrera(
      id: data['id'] ?? '',
      nombreCarrera: data['nombreCarrera'] ?? 'Carrera no especificada',
      escuelas: (data['escuelas'] as List<dynamic>? ?? [])
          .map((escuelaData) => Escuela.fromMap(escuelaData))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCarrera': nombreCarrera,
      'escuelas': escuelas.map((escuela) => escuela.toMap()).toList(),
    };
  }

  Carrera copyWith({String? id, String? nombreCarrera, List<Escuela>? escuelas}) {
    return Carrera(
      id: id ?? this.id,
      nombreCarrera: nombreCarrera ?? this.nombreCarrera,
      escuelas: escuelas?? this.escuelas,
    );
  }

}
