import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class OwnerCarsScreen extends StatefulWidget {
  final String nomPrenom;

  OwnerCarsScreen({required this.nomPrenom});

  @override
  _OwnerCarsScreenState createState() => _OwnerCarsScreenState();
}

class _OwnerCarsScreenState extends State<OwnerCarsScreen> {
  List<Map<String, String>> cars = [];
  bool isLoading = false;

  Future<void> fetchOwnerCars(String nomPrenom) async {
    setState(() {
      isLoading = true;
    });

    final apiUrl = endpoint+'Parking/FoundMycarWithUserName.php'; // Remplacez par votre URL d'API
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({'nom_prenom': nomPrenom}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, String>> fetchedCars = [];

      for (var car in jsonData) {
        fetchedCars.add({
          'matricule': car['matricule'],
          'parking_name': car['parking_name'],
          'position': car['position'],
        });
      }

      setState(() {
        cars = fetchedCars;
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
  void initState() {
    super.initState();
    fetchOwnerCars(widget.nomPrenom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voitures du '+widget.nomPrenom),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cars.isEmpty
          ? Center(child: Text('Aucune voiture trouvée'))
          : ListView.builder(
        itemCount: cars.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Matricule: ${cars[index]['matricule']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parking: ${cars[index]['parking_name']}'),
                Text('Position: ${cars[index]['position']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
