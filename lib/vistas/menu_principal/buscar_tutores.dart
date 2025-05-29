import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lfru_app/vistas/home/menu_lateral.dart';

class BuscarTutores extends StatelessWidget {
  const BuscarTutores({super.key});

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
              'ENCUENTRE LAS MEJORES TUTORIAS PERSONALIZADAS',
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
                width: 10, 
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20), 
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios, 
                  size: 16,
                  color: Colors.white.withOpacity(0.8), 
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: MenuLateral(logoutCallback: _logout), 
    );
  }
}
