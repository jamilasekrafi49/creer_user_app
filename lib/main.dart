import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <- ajouter cet import
import 'firebase_options.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/user/user_home_page.dart';
import 'screens/agent/agent_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creer User',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/user_home': (context) => UserHomePage(),
        '/agent_home': (context) => AgentHomePage(),
      },
    );
  }
}

// Widget pour vérifier si l'utilisateur est connecté et son rôle
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // maintenant ça fonctionne
    if (user == null) {
      return LoginPage();
    } else {
      // ici tu peux récupérer le rôle depuis Firestore si nécessaire
      return UserHomePage(); // ou AgentHomePage selon le rôle
    }
  }
}
