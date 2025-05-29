import 'package:cloud_firestore/cloud_firestore.dart';

class CargarEscuelas {

  // Función para obtener las escuelas desde Firestore
  static Future<List<String>> cargarEscuelas() async {
    try {
      // Obtener los documentos de la colección 'escuelas'
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('escuelas').get();

      // Mapear los datos de los documentos a una lista de escuelas
      List<String> carreras = snapshot.docs
          .map((doc) => doc['nombreEscuela'] as String)
          .toList();

      return carreras;
    } catch (e) {
      throw Exception("Error al cargar escuelas: $e");
    }
  }
}
