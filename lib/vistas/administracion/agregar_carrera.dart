import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/carrera.dart';
import 'package:lfru_app/models/escuela.dart';

class AgregarCarrera extends StatefulWidget {
  const AgregarCarrera({super.key});

  @override
  _AgregarCarreraState createState() => _AgregarCarreraState();
}

class _AgregarCarreraState extends State<AgregarCarrera> {
  final TextEditingController _nombreController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Escuela> _escuelasDisponibles = [];
  final List<Escuela> _escuelasSeleccionadas = [];

  @override
  void initState() {
    super.initState();
    _cargarEscuelasDisponibles();
  }

  Future<void> _cargarEscuelasDisponibles() async {
    final snapshot = await _firestore.collection('escuelas').get();
    setState(() {
      _escuelasDisponibles = snapshot.docs
          .map((doc) => Escuela.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> _agregarCarrera() async {
    String nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el nombre de la carrera')),
      );
      return;
    }

    Carrera nuevaCarrera = Carrera(
      id: '',
      nombreCarrera: nombre,
      escuelas: _escuelasSeleccionadas,
    );

    try {
      final docRef = await _firestore.collection('carreras').add(nuevaCarrera.toMap());
      nuevaCarrera = nuevaCarrera.copyWith(id: docRef.id);
      await docRef.update({'id': nuevaCarrera.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carrera agregada exitosamente')),
      );

      _nombreController.clear();
      setState(() {
        _escuelasSeleccionadas.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar carrera: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Carrera'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth < 600 ? constraints.maxWidth : 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              // ignore: sized_box_for_whitespace
              child: Container(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nombre de la Carrera',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        hintText: 'Ejemplo: Ingeniería de Sistemas',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Escuelas',
                      style: TextStyle(fontSize: 18),
                    ),
                    DropdownButtonFormField<Escuela>(
                      isExpanded: true,
                      hint: const Text('Selecciona una escuela'),
                      items: _escuelasDisponibles.map((escuela) {
                        return DropdownMenuItem(
                          value: escuela,
                          child: Text(escuela.nombreEscuela),
                        );
                      }).toList(),
                      onChanged: (escuelaSeleccionada) {
                        setState(() {
                          if (!_escuelasSeleccionadas.contains(escuelaSeleccionada)) {
                            _escuelasSeleccionadas.add(escuelaSeleccionada!);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: _escuelasSeleccionadas.map((escuela) {
                        return Chip(
                          label: Text(escuela.nombreEscuela),
                          onDeleted: () {
                            setState(() {
                              _escuelasSeleccionadas.remove(escuela);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: _agregarCarrera,
                        child: const Text('Agregar Carrera'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
