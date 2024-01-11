import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:welcomepage/constants.dart';
import 'dart:convert';
import 'index.dart';

class ConnexionPage extends StatefulWidget {
  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> connectUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      var requestBody = json.encode({
        'email': email,
        'password': password,
      });

      var response = await http.post(
        Uri.parse(endpoint + "/Users/Login.php"),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['code'] == 'success') {
          // Utilisateur connecté avec succès
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IndexPage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Erreur'),
              content: Text('Identifiants incorrects'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Erreur'),
            content: Text('Une erreur s\'est produite lors de la connexion'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez fournir l\'email et le mot de passe'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: connectUser,
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}