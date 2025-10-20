import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String role = 'agent'; // l'admin peut créer des agents ou users

  void addUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'role': role,
        'created_by': FirebaseAuth.instance.currentUser!.uid,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Utilisateur ajouté')));

      nameController.clear();
      emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil Admin'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Ajouter un utilisateur'),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            DropdownButton<String>(
              value: role,
              items: ['user', 'agent']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => role = val);
              },
            ),
            ElevatedButton(onPressed: addUser, child: Text('Ajouter')),
          ],
        ),
      ),
    );
  }
}

