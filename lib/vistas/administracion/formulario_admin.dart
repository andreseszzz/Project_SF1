import 'package:flutter/material.dart';
import 'agregar_escuela.dart';
import 'agregar_carrera.dart';
import 'agregar_facultad.dart';
// Importa las otras vistas cuando las tengas, como AgregarCarreraScreen y AgregarMateriaScreen

class FormularioAdmin extends StatelessWidget {
  const FormularioAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seleccione una opción para agregar:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Al presionar, va a la pantalla de agregar escuela
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgregarEscuela()),
                );
              },
              child: const Text('Agregar Escuela'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí iría la lógica para agregar carrera
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AgregarCarrera()));
              },
              child: const Text('Agregar Carrera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AgregarFacultad()));
              },
              child: const Text('Agregar Facultad'),
            ),
          ],
        ),
      ),
    );
  }
}
