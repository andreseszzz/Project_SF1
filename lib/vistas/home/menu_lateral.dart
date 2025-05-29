import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/models/user_mdel.dart';
import 'package:lfru_app/vistas/administracion/formulario_admin.dart';
import 'package:lfru_app/vistas/menu_principal/buscar_grupos_estudio.dart';
import 'package:lfru_app/vistas/menu_principal/ver_notificaciones.dart';
import 'package:lfru_app/vistas/perfil_screens/editar_perfil.dart';
import 'package:lfru_app/vistas/perfil_screens/perfil.dart';
import 'package:lfru_app/vistas/menu_principal/crear_grupo.dart';
import 'package:lfru_app/vistas/menu_principal/buscar_tutores.dart';
import 'package:lfru_app/vistas/menu_principal/mis_grupos.dart';
import 'package:lfru_app/vistas/menu_principal/aplicar_ser_tutor.dart';
import 'package:lfru_app/vistas/menu_principal/mis_solicitudes_tutor.dart';
import 'package:lfru_app/vistas/menu_principal/solicitar_certificado_tutor.dart';

class MenuLateral extends StatefulWidget {
  final Function(BuildContext) logoutCallback;

  const MenuLateral({required this.logoutCallback, super.key});

  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  Future<UserModel?> getUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return null; // No hay usuario autenticado
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        throw 'El documento no existe'; // Si el documento no existe
      }
    } catch (e) {
      // Aquí capturamos cualquier error que ocurra (como la falta de conexión o problemas con el campo 'groups')
      // ignore: avoid_print
      print('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<UserModel?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                    child: Text('Error al cargar del usuario'));
              }

              final user = snapshot.data;

              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight * 0.3,
                    color: Colors.lightGreen, // Fondo verde claro
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfileScreen(user: user)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Datos de usuario no disponibles')),
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user?.imageUrl ??
                                'https://via.placeholder.com/150'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${user?.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          user?.title ?? 'Título por defecto',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.carrera ?? 'carrera por defecto',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // OPCIONES PARA TODOS LOS USUARIOS
                  ListTile(
                    leading: const Icon(Icons.device_hub),
                    title: const Text('Editar perfil'),
                    onTap: () {
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileScreen(user: user)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Datos de usuario no disponibles')),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Crear grupo de estudio'),
                    onTap: () {
                      if (user != null) {
                        // Pasa el usuario obtenido desde Firestore a CrearGrupoEstudio
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CrearGrupoEstudio(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Datos de usuario no disponibles')),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Buscar Grupos de estudio'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuscarGruposEstudio()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Mis grupos de estudio'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MisGrupos()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Buscar Tutores Personales'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuscarTutores()),
                      );
                    },
                  ),
                  // OPCIONES PARA TUTORES
                  if (user?.title == 'Tutor' &&
                      user?.title != 'Administrador') ...[
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text('Aplicar para tutor personal'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AplicarSerTutor()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.assignment),
                      title: const Text('Mis solicitudes para tutor'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MisSolicitudesTutor()),
                        );
                      },
                    ),
                  ],
                  if (user?.title != 'Tutor' &&
                      user?.title != 'Administrador') ...[
                    ListTile(
                      leading: const Icon(Icons.checklist_rtl),
                      title: const Text('Solicitar certificado de tutor'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) =>
                                  const SolicitarCertificadoTutor()),
                        );
                      },
                    ),
                  ],
                  if (user?.title != 'Estudiante' &&
                      user?.title != 'Tutor') ...[
                    ListTile(
                      leading: const Icon(Icons.checklist_rtl),
                      title: const Text('Aministracion'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => const FormularioAdmin()),
                        );
                      },
                    ),
                  ],
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notificaciones'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerNotificaciones()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    onTap: () => widget.logoutCallback(context),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
