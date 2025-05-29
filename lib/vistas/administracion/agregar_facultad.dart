import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/carrera.dart';
import 'package:lfru_app/models/facultad.dart';

class AgregarFacultad extends StatefulWidget {
  const AgregarFacultad({super.key});

  @override
  _AgregarFacultadState createState() => _AgregarFacultadState();
}

class _AgregarFacultadState extends State<AgregarFacultad> {
  final TextEditingController _nombreController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Carrera> _carrerasDisponibles = [];
  final List<Carrera> _carrerasSeleccionadas = [];

  @override
  void initState() {
    super.initState();
    _cargarCarrerasDisponibles();
  }

  // Cargar las carreras disponibles desde Firestore
  Future<void> _cargarCarrerasDisponibles() async {
    final snapshot = await _firestore.collection('carreras').get();
    setState(() {
      _carrerasDisponibles = snapshot.docs.map((doc) => Carrera.fromMap(doc.data())).toList();
    });
  }

  // Lógica para guardar la facultad en Firestore
  Future<void> _agregarFacultad() async {
    String nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el nombre de la facultad')),
      );
      return;
    }

    Facultad nuevaFacultad = Facultad(
      id: '',
      nombreFacultad: nombre,
      carreras: _carrerasSeleccionadas,
    );

    try {
      final docRef = await _firestore.collection('facultad').add(nuevaFacultad.toMap());
      nuevaFacultad = nuevaFacultad.copyWith(id: docRef.id);
      await docRef.update({'id': nuevaFacultad.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facultad agregada exitosamente')),
      );

      _nombreController.clear();
      setState(() {
        _carrerasSeleccionadas.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar facultad: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Facultad'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth > 600 ? 32.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre de la Facultad',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(hintText: 'Ejemplo: Facultad de Fisicomecánicas'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Carreras',
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButtonFormField<Carrera>(
                  isExpanded: true,
                  hint: const Text('Selecciona una Carrera'),
                  items: _carrerasDisponibles.map((carrera) {
                    return DropdownMenuItem(
                      value: carrera,
                      child: Text(carrera.nombreCarrera),
                    );
                  }).toList(),
                  onChanged: (carreraSeleccionada) {
                    setState(() {
                      if (!_carrerasSeleccionadas.contains(carreraSeleccionada)) {
                        _carrerasSeleccionadas.add(carreraSeleccionada!);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _carrerasSeleccionadas.map((carrera) {
                    return Chip(
                      label: Text(carrera.nombreCarrera),
                      onDeleted: () {
                        setState(() {
                          _carrerasSeleccionadas.remove(carrera);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _agregarFacultad,
                    child: const Text('Agregar Facultad'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
