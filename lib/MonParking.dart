import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ParkingDetails {
  final String nomParking;
  final String ville;
  final int capaciteMax;
  final double rate;
  final int nombreAvis;
  final String matricule;
  final String positionDansParking;

  ParkingDetails({
    required this.nomParking,
    required this.ville,
    required this.capaciteMax,
    required this.rate,
    required this.nombreAvis,
    required this.matricule,
    required this.positionDansParking,
  });
}

class ParkingInfoScreen extends StatefulWidget {
  final String nomPrenom;

  ParkingInfoScreen({required this.nomPrenom});

  @override
  _ParkingInfoScreenState createState() => _ParkingInfoScreenState();
}

class _ParkingInfoScreenState extends State<ParkingInfoScreen> {
  List<ParkingDetails> parkingDetails = [];
  bool isLoading = false;

  Future<void> fetchParkingDetails(String nomPrenom) async {
    setState(() {
      isLoading = true;
    });

    final apiUrl = endpoint+'Parking/ParkingInformation.php'; // Remplacez par votre URL d'API
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({'nom_prenom': nomPrenom}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<ParkingDetails> fetchedParkingDetails = [];

      for (var parking in jsonData) {
        fetchedParkingDetails.add(ParkingDetails(
          nomParking: parking['NomParking'],
          ville: parking['Ville'],
          capaciteMax: int.parse(parking['CapaciteMax']),
          rate: double.parse(parking['Rate']),
          nombreAvis: int.parse(parking['NombreAvis']),
          matricule: parking['Voitures']['Matricule'],
          positionDansParking: parking['Voitures']['PositionDansParking'],
        ));
      }

      setState(() {
        parkingDetails = fetchedParkingDetails;
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
    fetchParkingDetails(widget.nomPrenom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du parking'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: parkingDetails.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(parkingDetails[index].nomParking),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ville: ${parkingDetails[index].ville}'),
                Text('Capacité maximale: ${parkingDetails[index].capaciteMax}'),
                Text('Rate: ${parkingDetails[index].rate}'),
                Text('Nombre d\'avis: ${parkingDetails[index].nombreAvis}'),
                Text('Matricule: ${parkingDetails[index].matricule}'),
                Text('Position dans le parking: ${parkingDetails[index].positionDansParking}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
