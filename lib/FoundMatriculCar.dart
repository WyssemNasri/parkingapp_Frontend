import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:welcomepage/constants.dart';

class CarLocationScreen extends StatefulWidget {
  final String userName;

  CarLocationScreen({required this.userName});

  @override
  _CarLocationScreenState createState() => _CarLocationScreenState();
}

class _CarLocationScreenState extends State<CarLocationScreen> {
  String parkingName = '';
  String position = '';
  bool isLoading = false;
  TextEditingController matriculeController = TextEditingController();

  Future<void> findCarLocation(String matricule) async {
    setState(() {
      isLoading = true;
    });

    final apiUrl = endpoint + 'Parking/FoundMyCarMatricule.php'; // Replace with your API endpoint
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({'matricule': matricule}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        parkingName = jsonData['parking_name'];
        position = jsonData['position'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Erreur lors de la récupération des données'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emplacement de la voiture'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: matriculeController,
                decoration: InputDecoration(
                  labelText: 'Matricule de la voiture',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Call the function to find car location when button is pressed
                  String matricule = matriculeController.text;
                  findCarLocation(matricule);
                },
                child: Text('Trouver l\'emplacement de la voiture'),
              ),
              SizedBox(height: 20.0),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Parking: $parkingName',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Position: $position',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
