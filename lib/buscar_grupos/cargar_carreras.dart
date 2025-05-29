import 'package:cloud_firestore/cloud_firestore.dart';

class CargarCarreras {

  // Función para obtener las carreras desde Firestore
  static Future<List<String>> cargarCarreras() async {
    try {
      // Obtener los documentos de la colección 'carreras'
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('carreras').get();

      // Mapear los datos de los documentos a una lista de carreras
      List<String> carreras = snapshot.docs
          .map((doc) => doc['nombreCarrera'] as String)
          .toList();

      return carreras;
    } catch (e) {
      throw Exception("Error al cargar carreras: $e");
    }
  }
}
