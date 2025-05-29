import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'menu_lateral.dart'; // Importa el archivo del menú

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text(
              '¡Bienvenido a la pantalla de inicio!',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  Scaffold.of(context).openDrawer();
                }
              },
              child: Container(
                width: 10, // Cambiamos a una franja más delgada
                height: 80, // Tamaño más pequeño para que no sea llamativo
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5), // Color gris claro
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20), 
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios, // Ícono como pista visual
                  size: 16,
                  color: Colors.white.withOpacity(0.8), // Ícono discreto
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: MenuLateral(logoutCallback: _logout), // Pasamos la función de logout al menú
    );
  }
}
