import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lfru_app/firebase_options.dart';
import 'package:lfru_app/vistas/iniciar_sesion/login.dart';
import 'package:lfru_app/vistas/iniciar_sesion/registro.dart';
import 'package:lfru_app/vistas/menu_principal/mis_grupos.dart'; // Asegúrate de que esta ruta sea correcta

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LFRU-UIS',
      theme: ThemeData(
        fontFamily: 'Open Sans', 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // RUTAS HACIA LAS VISTAS
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/mis_grupos': (context) => const MisGrupos(),
        '/registro': (context) => const RegistroPage(),  // Ajusta según tu pantalla de inicio
      },
    );
  }
}
