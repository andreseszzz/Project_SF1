class Escuela {
  final String id;
  final String nombreEscuela;
  final List<String> materias;

  Escuela({required this.id, required this.nombreEscuela, required this.materias});

  // Convertimos un Map en una instancia de Escuela
  factory Escuela.fromMap(Map<String, dynamic> data) {
    return Escuela(
      id: data['id'] ?? '',
      nombreEscuela: data['nombreEscuela'] ?? 'Escuela no especificada',
      materias: List<String>.from(data['materias'] ?? []), 
    );
  }

  // Convertimos una instancia de Escuela en un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreEscuela': nombreEscuela,
      'materias': materias,
    };
  }

  // Agregamos el método copyWith
  Escuela copyWith({String? id, String? nombreEscuela, List<String>? materias}) {
    return Escuela(
      id: id ?? this.id,
      nombreEscuela: nombreEscuela ?? this.nombreEscuela,
      materias: materias ?? this.materias,
    );
  }
}
