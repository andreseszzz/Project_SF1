// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfru_app/vistas/iniciar_sesion/registro.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrUserController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      String email = _emailOrUserController.text.trim();
      String password = _passwordController.text.trim();

      UserCredential userCredential;

      if (email.contains('@')) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        var snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('usuario', isEqualTo: email)
            .get();

        if (snapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuario no encontrado.")),
          );
          return;
        }

        String emailFromDb = snapshot.docs.first['correo'];

        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailFromDb,
          password: password,
        );
      }

      User? user = userCredential.user;

      if (user != null && user.emailVerified) {
        Navigator.pushReplacementNamed(
            context, '/mis_grupos'); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor verifica tu correo antes de iniciar sesión.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(153, 84, 230, 59),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Text(
                'Bienvenido de vuelta!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Inicie Sesión y busque sus grupos de estudio',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 225, 225, 225),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              TextField(
                controller: _emailOrUserController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico o Usuario',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(196, 225, 225, 225),
                  ),
                  fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                  filled: true,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(196, 225, 225, 225),
                  ),
                  fillColor: Color.fromRGBO(26, 186, 66, 0.498),
                  filled: true,
                ),
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Lógica para restablecer la contraseña
                  },
                  child: const Text(
                    '¿Olvidó su contraseña?',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes una cuenta?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>const RegistroPage()));
                    },
                    child: const Text(
                      'Regístrate aquí',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Espacio adicional
            ],
          ),
        ),
      ),
    );
  }
}
