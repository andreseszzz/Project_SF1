import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/grupos_model.dart';

class ObtenerGrupos {
  static Future<List<GruposModel>> obtenerGrupos(
    String facultad, 
    String carrera, 
    String escuela, {
    String? grupoId, // Parámetro opcional para buscar por ID de grupo
  }) async {
    try {
      QuerySnapshot snapshot;

      if (grupoId != null && grupoId.isNotEmpty) {
        // Si el ID de grupo es proporcionado, buscamos directamente por ID
        snapshot = await FirebaseFirestore.instance
            .collection('grupos_estudio')
            .where('idGrupo', isEqualTo: grupoId) // Buscamos por ID de grupo
            .get();
      } else {
        // Si no se proporciona el ID de grupo, buscamos por facultad, carrera y escuela
        snapshot = await FirebaseFirestore.instance
            .collection('grupos_estudio')
            .where('facultad', isEqualTo: facultad) 
            .where('carrera', isEqualTo: carrera) 
            .where('escuela', isEqualTo: escuela)  
            .get();
      }

      List<GruposModel> gruposDisponibles = snapshot.docs.map((doc) {
        return GruposModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return gruposDisponibles;
    } catch (e) {
      throw Exception('No se pudo obtener la lista de grupos: $e');
    }
  }
}
