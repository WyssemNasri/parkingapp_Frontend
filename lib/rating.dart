import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'Dashboard.dart';
import 'constants.dart';

void main() {
  runApp(MaterialApp(
    home: RatingApp(),
  ));
}

class Parking {
  final String name;
  final double rate;

  Parking({required this.name, required this.rate});
}

class RatingApp extends StatefulWidget {
  @override
  _RatingAppState createState() => _RatingAppState();
}

class _RatingAppState extends State<RatingApp> {
  List<Parking> Parkings = [];

  @override
  void initState() {
    super.initState();
    fetchParkings().then((ParkingsList) {
      setState(() {
        Parkings = ParkingsList;
      });
    });
  }

  Future<List<Parking>> fetchParkings() async {
    final apiUrl = endpoint + "Parking/ParkingList.php";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData); // Print response body for debugging

      if (jsonData['code'] == 'success' && jsonData.containsKey('data')) {
        List<Parking> Parkings = [];

        for (var ParkingData in jsonData['data']) {
          if (ParkingData is Map &&
              ParkingData.containsKey('nom_parking') &&
              ParkingData.containsKey('rate')) {
            Parking parking = Parking(
              name: ParkingData['nom_parking'].toString(),
              rate: double.parse(ParkingData['rate'].toString()),
            );
           Parkings.add(parking);
          }
        }

        return Parkings;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception(
          'Erreur lors de l\'appel à l\'API : ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Parkings.sort((a, b) => b.rate.compareTo(a.rate));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liste des Parkins ',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Liste des Parkins'),
          elevation: 0,
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            itemCount: Parkings.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RateParkingScreen(parking: Parkings[index]),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Parkings[index].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            'Rate: ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.0,
                          ),
                          Text(
                            Parkings[index].rate.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RateParkingScreen extends StatefulWidget {
  final Parking parking;

  RateParkingScreen({required this.parking});

  @override
  _RateParkingScreenState createState() => _RateParkingScreenState();
}

class _RateParkingScreenState extends State<RateParkingScreen> {
  double overallRating = 0.0;

  void _updateOverallRating(double rating) {
    setState(() {
      overallRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate ${widget.parking.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Overall Rating:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            RatingBar.builder(
              initialRating: overallRating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40.0,
              itemBuilder: (context, _) =>
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              onRatingUpdate: _updateOverallRating,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60)),
              onPressed: () {
                rate();

                Navigator.pop(context);
              },
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }

  void rate() async {
    final apiUrl = endpoint + '/Rate/Rate.php';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'rate': overallRating.toString(),
          'nom_parking': widget.parking.name,
        }),
      );

      if (response.statusCode == 200) {
        // Rating successfully saved
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(userName: '', userEmail: ''),
          ),
        );
      } else {
        // Handle the error
        print('Failed to save rating: ${response.statusCode}');
        // Afficher un message à l'utilisateur pour informer sur l'échec de la soumission de la note
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Échec de la soumission de la note'),
              content: Text(
                  'Impossible d\'envoyer la note pour le moment. Veuillez réessayer plus tard.'),
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
    } catch (error) {
      // Handle other types of errors like network issues
      print('Error: $error');
      // Afficher un message à l'utilisateur pour informer sur l'échec de la soumission de la note en raison d'une erreur
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec de la soumission'),
            content: Text(
                'Une erreur s\'est produite lors de l\'envoi de la note. Veuillez réessayer.'),
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
}