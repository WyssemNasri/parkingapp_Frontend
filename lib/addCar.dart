import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajouter une voiture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddCarPage(),
    );
  }
}

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _proprietaireController = TextEditingController();
  final TextEditingController _parkingNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  Future<void> _addCar() async {

    final response = await http.post(
      Uri.parse(endpoint+"Parking/AddCar.php"),
      body: jsonEncode({
        'matricule': _matriculeController.text,
        'proprietaire': _proprietaireController.text,
        'parking_name': _parkingNameController.text,
        'position': _positionController.text
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Succès'),
          content: Text('Voiture ajoutée au parking avec succès'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Erreur
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Échec lors de l\'ajout de la voiture au parking'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
        title: Text('Ajouter une voiture'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _matriculeController,
                decoration: InputDecoration(labelText: 'Matricule'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez le matricule';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proprietaireController,
                decoration: InputDecoration(labelText: 'Propriétaire'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez le nom du propriétaire';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _parkingNameController,
                decoration: InputDecoration(labelText: 'Nom du parking'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez le nom du parking';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position dans le parking'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez la position dans le parking';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addCar();
                  }
                },
                child: Text('Ajouter la voiture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
