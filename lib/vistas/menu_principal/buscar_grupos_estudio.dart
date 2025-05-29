import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/buscar_grupos/obtener_grupos.dart';
import 'package:lfru_app/models/grupos_model.dart';
import 'package:lfru_app/vistas/home/menu_lateral.dart';
import 'package:lfru_app/buscar_grupos/cargar_escuelas.dart';
import 'package:lfru_app/buscar_grupos/cargar_carreras.dart';
import 'package:lfru_app/buscar_grupos/cargar_facultades.dart';
import 'package:lfru_app/buscar_grupos/mostrar_grupos.dart';

class BuscarGruposEstudio extends StatefulWidget {
  const BuscarGruposEstudio({super.key});

  @override
  _BuscarGruposEstudioState createState() => _BuscarGruposEstudioState();
}

class _BuscarGruposEstudioState extends State<BuscarGruposEstudio> {
  List<String> facultades = [];
  List<String> escuelas = [];
  List<String> carreras = [];
  String? facultadSeleccionada;
  String? escuelaSeleccionada;
  String? carreraSeleccionada;
  String? idGrupo;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      List<String> facultadesList = await CargarFacultades.cargarFacultades();
      List<String> escuelasList = await CargarEscuelas.cargarEscuelas();
      List<String> carrerasList = await CargarCarreras.cargarCarreras();

      setState(() {
        facultades = facultadesList;
        escuelas = escuelasList;
        carreras = carrerasList;

        if (facultades.isNotEmpty) {
          facultadSeleccionada = facultades.first;
        }

        if (escuelas.isNotEmpty) {
          escuelaSeleccionada = escuelas.first;
        }

        if (carreras.isNotEmpty) {
          carreraSeleccionada = carreras.first;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar datos: $e")),
      );
    }
  }

  Future<void> _buscarGrupos() async {
    try {
      List<GruposModel> grupos = await ObtenerGrupos.obtenerGrupos(
        facultadSeleccionada!,
        carreraSeleccionada!,
        escuelaSeleccionada!,
        grupoId: idGrupo,
      );

      // Navegar a la pantalla MostrarGrupos y pasar los grupos filtrados
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MostrarGrupos(grupos: grupos),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar grupos: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Grupos de Estudio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Conoces el ID del grupo?', style: TextStyle(fontSize: 16)),
            TextField(
              onChanged: (value) {
                setState(() {
                  idGrupo = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Ingresa el ID del grupo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Si no lo conoces, utiliza los filtros:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: facultadSeleccionada,
              hint: const Text('Selecciona la Facultad'),
              items: facultades.map((String facultad) {
                return DropdownMenuItem<String>(
                  value: facultad,
                  child: Text(facultad),
                );
              }).toList(),
              onChanged: (String? nuevaFacultad) {
                setState(() {
                  facultadSeleccionada = nuevaFacultad;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: escuelaSeleccionada,
              hint: const Text('Selecciona la Escuela'),
              items: escuelas.map((String escuela) {
                return DropdownMenuItem<String>(
                  value: escuela,
                  child: Text(escuela),
                );
              }).toList(),
              onChanged: (String? nuevaEscuela) {
                setState(() {
                  escuelaSeleccionada = nuevaEscuela;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: carreraSeleccionada,
              hint: const Text('Selecciona la Carrera'),
              items: carreras.map((String carrera) {
                return DropdownMenuItem<String>(
                  value: carrera,
                  child: Text(carrera),
                );
              }).toList(),
              onChanged: (String? nuevaCarrera) {
                setState(() {
                  carreraSeleccionada = nuevaCarrera;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _buscarGrupos,
              child: const Text('Buscar Grupos'),
            ),
          ],
        ),
      ),
      drawer: MenuLateral(logoutCallback: _logout),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }
}
