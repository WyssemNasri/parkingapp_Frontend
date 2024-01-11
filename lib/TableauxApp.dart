import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.userName}) : super(key: key);

  final String? userName;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String acceptedCount = '0';
  String rejectedCount = '0';
  String pendingCount = '0';
  final TextEditingController _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _envoyerCle();
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _envoyerCle() async {
    final response = await http.post(
      Uri.parse(endpoint +"Statistique/statistique.php"),
      body: json.encode({'nomPrenom': widget.userName}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final countData = data['data'];

      setState(() {
        acceptedCount = countData['accepted_count'];
        rejectedCount = countData['refused_count'];
        pendingCount = countData['waiting_count'];
      });
    } else {
      print('Erreur lors de la requête API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.blue,
              width: 0,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage du message avec le nom d'utilisateur
              Center(
                child: Text(
                  'Vos statistiques MR. ${widget.userName ?? ""}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircle('Acceptés', acceptedCount, Colors.green),
                  SizedBox(width: 20),
                  _buildCircle('Refusés', rejectedCount, Colors.red),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircle('En attente', pendingCount, Colors.yellow),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(String label, String count, Color color) {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
