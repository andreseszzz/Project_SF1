import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lfru_app/models/user_mdel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({required this.user, super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController descripcionController;
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    descripcionController =
        TextEditingController(text: widget.user.descripcion);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    String? imageUrl = widget.user.imageUrl;

    try {
      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images/${FirebaseAuth.instance.currentUser?.uid}.jpg');
        final uploadTask = await storageRef.putFile(_image!);

        if (uploadTask.state == TaskState.success) {
          imageUrl = await storageRef.getDownloadURL();
        } else {
          throw Exception('Error al subir la imagen');
        }
      }

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
        'name': nameController.text, // Actualiza el campo de nombre
        'descripcion': descripcionController.text,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfile, // Guardar los cambios
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Envolver la columna en un scroll view
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Seleccionar nueva imagen
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : NetworkImage(widget.user.imageUrl) as ImageProvider,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Sobre tí'),
                maxLines: 5, // Campo de varias líneas
              ),
            ],
          ),
        ),
      ),
    );
  }
}
