import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/grupos_model.dart';
import 'package:lfru_app/models/user_mdel.dart';

class CrearGrupoEstudio extends StatefulWidget {
  const CrearGrupoEstudio({super.key});

  @override
  _CrearGrupoEstudioState createState() => _CrearGrupoEstudioState();
}

class _CrearGrupoEstudioState extends State<CrearGrupoEstudio> {
  final TextEditingController _nombreGrupoController = TextEditingController();
  final TextEditingController _descripcionGrupoController =
      TextEditingController();
  final TextEditingController _cuposController = TextEditingController();
  final TextEditingController _temaController = TextEditingController();

  UserModel? usuarioActual;
  bool _tutor = false;

  List<String> facultades = [];
  List<String> escuelas = [];
  List<String> carreras = [];
  List<String> materias = [];

  String? selectedFacultad;
  String? selectedEscuela;
  String? selectedCarrera;
  String? selectedMateria;

  @override
  void initState() {
    super.initState();
    getUserData();
    loadOptions();
  }

  Future<UserModel?> getUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return null;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();

    usuarioActual = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    _tutor = usuarioActual?.title == 'Tutor';
    setState(() {}); // Para reflejar el cambio en la interfaz
    return usuarioActual;
  }

  Future<void> loadOptions() async {
    final facultadesSnapshot =
        await FirebaseFirestore.instance.collection('facultad').get();
    final escuelasSnapshot =
        await FirebaseFirestore.instance.collection('escuelas').get();
    final carrerasSnapshot =
        await FirebaseFirestore.instance.collection('carreras').get();

    setState(() {
      facultades = facultadesSnapshot.docs
          .map((doc) => doc['nombreFacultad'] as String)
          .toList();
      escuelas = escuelasSnapshot.docs
          .map((doc) => doc['nombreEscuela'] as String)
          .toList();
      carreras = carrerasSnapshot.docs
          .map((doc) => doc['nombreCarrera'] as String)
          .toList();
      materias = escuelasSnapshot.docs
          .expand((doc) => List<String>.from(doc['materias'] ?? []))
          .toList();
    });
  }

  Future<void> _crearGrupoEstudio() async {
    if (usuarioActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no encontrado')),
      );
      return;
    }

    try {
      // Crear el grupo en Firestore
      GruposModel nuevoGrupo = GruposModel(
        propietario:
            usuarioActual!, // Usa el ID del usuario en lugar del objeto completo
        nombreGrupo: _nombreGrupoController.text.trim(),
        idGrupo: '',
        descripcionGrupo: _descripcionGrupoController.text.trim(),
        cupos: int.parse(_cuposController.text.trim()),
        facultad: selectedFacultad ?? '',
        escuela: selectedEscuela ?? '',
        carrera: selectedCarrera ?? '',
        materia: selectedMateria ?? '',
        tema: _temaController.text.trim(),
        fecha: DateTime.now(),
        tutor: _tutor,
      );

      // Agregar el grupo a la colección 'grupos_estudio'
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('grupos_estudio')
          .add(nuevoGrupo.toMap());

      // Actualizar el ID del grupo en Firestore
      await docRef.update({'idGrupo': docRef.id});

      // Añadir el nuevo grupo al usuario
      nuevoGrupo.idGrupo = docRef.id;
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'groups': FieldValue.arrayUnion([nuevoGrupo.toMap()]),
      });

      // Mostrar mensaje de éxito y regresar a la pantalla anterior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grupo de estudio creado exitosamente.')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Grupo de Estudio'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nombreGrupoController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del grupo'),
              ),
              TextField(
                controller: _descripcionGrupoController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: _cuposController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cupos'),
              ),
              DropdownButtonFormField<String>(
                value: selectedFacultad,
                items: facultades.map((String facultad) {
                  return DropdownMenuItem<String>(
                    value: facultad,
                    child: Text(facultad),
                  );
                }).toList(),
                onChanged: (newValue) =>
                    setState(() => selectedFacultad = newValue),
                decoration: const InputDecoration(labelText: 'Facultad'),
              ),
              DropdownButtonFormField<String>(
                value: selectedEscuela,
                items: escuelas.map((String escuela) {
                  return DropdownMenuItem<String>(
                    value: escuela,
                    child: Text(escuela),
                  );
                }).toList(),
                onChanged: (newValue) =>
                    setState(() => selectedEscuela = newValue),
                decoration: const InputDecoration(labelText: 'Escuela'),
              ),
              DropdownButtonFormField<String>(
                value: selectedCarrera,
                items: carreras.map((String carrera) {
                  return DropdownMenuItem<String>(
                    value: carrera,
                    child: Text(carrera),
                  );
                }).toList(),
                onChanged: (newValue) =>
                    setState(() => selectedCarrera = newValue),
                decoration: const InputDecoration(labelText: 'Carrera'),
              ),
              DropdownButtonFormField<String>(
                value: selectedMateria,
                items: materias.map((String materia) {
                  return DropdownMenuItem<String>(
                    value: materia,
                    child: Text(materia),
                  );
                }).toList(),
                onChanged: (newValue) =>
                    setState(() => selectedMateria = newValue),
                decoration: const InputDecoration(labelText: 'Materia'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _crearGrupoEstudio,
                child: const Text('Crear grupo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
