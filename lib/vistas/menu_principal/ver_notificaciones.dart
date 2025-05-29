import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/logica_solicitudes/aceptar_solicitud.dart';
import 'package:lfru_app/logica_solicitudes/borrar_notificacion.dart';
import 'package:lfru_app/logica_solicitudes/obtener_notificaciones.dart';
import 'package:lfru_app/logica_solicitudes/rechazar_solicitud.dart';
import 'package:lfru_app/models/notificaciones_model.dart';
import 'package:lfru_app/vistas/home/menu_lateral.dart';

class VerNotificaciones extends StatefulWidget {
  const VerNotificaciones({super.key});

  @override
  State<VerNotificaciones> createState() => _VerNotificacionesState();
}

class _VerNotificacionesState extends State<VerNotificaciones> {
  final user = FirebaseAuth.instance.currentUser;
  late Future<List<NotificacionesModel>> _notificacionesFuture;

  @override
  void initState() {
    super.initState();
    _notificacionesFuture = _obtenerNotificaciones(user!.email!);
  }

  Future<List<NotificacionesModel>> _obtenerNotificaciones(String correo) async {
    try {
      final obtenerNotificaciones = ObtenerNotificaciones();
      return await obtenerNotificaciones.obtenerNotificaciones(correo);
    } catch (e) {
      print("Error obteniendo notificaciones: $e");
      return [];
    }
  }

  void _reloadNotifications() {
    setState(() {
      _notificacionesFuture = _obtenerNotificaciones(user!.email!);
    });
  }

  Future<void> _aceptarSolicitud(NotificacionesModel notificacion) async {
    AceptarSolicitud().aceptarSolicitud(
      notificacion.idNotificacion,
      notificacion.origen,
      notificacion.idRequerido,
    );
    _reloadNotifications();
  }

  Future<void> _rechazarSolicitud(NotificacionesModel notificacion) async {
     RechazarSolicitud.rechazarSolicitud(
      notificacion.idNotificacion,
      notificacion.origen,
      notificacion.destino,
      notificacion.idRequerido,
    );
    _reloadNotifications();
  }

  Future<void> _borrarNotificacion(String idNotificacion) async {
    await BorrarNotificacion().borrarNotificaciones(idNotificacion);
    _reloadNotifications();
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || user!.email == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis Notificaciones')),
        body: const Center(
          child: Text('No se encontró un usuario autenticado.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: FutureBuilder<List<NotificacionesModel>>(
        future: _notificacionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar las notificaciones: ${snapshot.error}'),
            );
          }
          final notificaciones = snapshot.data ?? [];
          if (notificaciones.isEmpty) {
            return const Center(child: Text('No tienes notificaciones.'));
          }

          return ListView.builder(
            itemCount: notificaciones.length,
            itemBuilder: (context, index) {
              final notificacion = notificaciones[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificacion.titulo,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notificacion.cuerpo,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      if (notificacion.tipo == 'solicitud_grupo') ...[
                        if (!notificacion.leida) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () => _aceptarSolicitud(notificacion),
                                  tooltip: "Aceptar",
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _rechazarSolicitud(notificacion),
                                  tooltip: "Rechazar",
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.grey),
                                  onPressed: () => _borrarNotificacion(notificacion.idNotificacion),
                                  tooltip: "Borrar",
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey),
                                onPressed: () => _borrarNotificacion(notificacion.idNotificacion),
                                tooltip: "Borrar",
                              ),
                            ],
                          ),
                        ],
                      ] else if (notificacion.tipo == 'solicitud_aceptada') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => _borrarNotificacion(notificacion.idNotificacion),
                              tooltip: "Borrar",
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      drawer: MenuLateral(logoutCallback: _logout),
    );
  }
}
