import 'package:cloud_firestore/cloud_firestore.dart';

class CargarFacultades {

  // Función para obtener las carreras desde Firestore
  static Future<List<String>> cargarFacultades() async {
    try {
      // Obtener los documentos de la colección 'Facultades'
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('facultad').get();

      // Mapear los datos de los documentos a una lista de facultades
      List<String> carreras = snapshot.docs
          .map((doc) => doc['nombreFacultad'] as String)
          .toList();

      return carreras;
    } catch (e) {
      throw Exception("Error al cargar carreras: $e");
    }
  }
}
