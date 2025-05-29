import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/models/escuela.dart';

class AgregarEscuela extends StatefulWidget {
  const AgregarEscuela({super.key});

  @override
  _AgregarEscuelaScreenState createState() => _AgregarEscuelaScreenState();
}

class _AgregarEscuelaScreenState extends State<AgregarEscuela> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _materiasController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lógica para guardar la escuela en Firestore
  Future<void> _agregarEscuela() async {
    String nombre = _nombreController.text.trim();
    List<String> materias = _materiasController.text
        .split(',')
        .map((materia) => materia.trim())
        .toList();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el nombre de la escuela')),
      );
      return;
    }

    Escuela nuevaEscuela = Escuela(
      id: '',
      nombreEscuela: nombre,
      materias: materias,
    );

    try {
      final docRef = await _firestore.collection('escuelas').add(nuevaEscuela.toMap());
      nuevaEscuela = nuevaEscuela.copyWith(id: docRef.id);
      await docRef.update({'id': nuevaEscuela.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escuela agregada exitosamente')),
      );

      _nombreController.clear();
      _materiasController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar escuela: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Escuela'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Ajuste de ancho máximo para una mejor presentación en pantallas grandes
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
                      'Nombre de la Escuela',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        hintText: 'Ejemplo: Escuela de Matematicas',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Materias (separadas por comas)',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextField(
                      controller: _materiasController,
                      decoration: const InputDecoration(
                        hintText: 'Ejemplo: Calculo I, Algebra, Ecuaciones ',
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: _agregarEscuela,
                        child: const Text('Agregar Escuela'),
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
