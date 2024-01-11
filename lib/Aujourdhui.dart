import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'constants.dart';

class Appointment {
  final String doctorName;
  final DateTime dateTime;

  Appointment({
    required this.doctorName,
    required this.dateTime,
  });
}

class Aujourdhui extends StatefulWidget {
  const Aujourdhui({Key? key}) : super(key: key);

  @override
  _AujourdhuiState createState() => _AujourdhuiState();
}

class _AujourdhuiState extends State<Aujourdhui> {
  List<Appointment> appointments = [];
  TextEditingController patientKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchAppointments() async {
    final String patientKey = patientKeyController.text;

    http.Response response = await http.post(
      Uri.parse(endpoint + "/Rendezvous/patient_redevus.php"),
      body: json.encode({'patient_key': patientKey}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['result'] == 'success' && jsonData.containsKey('message')) {
        final data = jsonData['message'];

        final appointmentsList = data.map<Appointment>((appointmentJson) {
          final date = DateTime.parse(appointmentJson['date'].toString());
          final time = DateFormat.Hm().parse(appointmentJson['time'].toString());
          final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

          return Appointment(
            doctorName: appointmentJson['doctor_name'].toString(),
            dateTime: dateTime,
          );
        }).toList();

        setState(() {
          appointments = appointmentsList;
        });
      } else if (jsonData['result'] == 'empty') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Empty'),
            content: Text(jsonData['message'].toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid response format'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch appointments'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos rendez-vous'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: patientKeyController,
              decoration: InputDecoration(
                labelText: 'Clé du patient',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: fetchAppointments,
            child: Text('Voir les rendez-vous'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Médecin: ${appointment.doctorName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Text(
                          'Date: ${formatDate(appointment.dateTime.toString())}',
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Heure: ${DateFormat.Hm().format(appointment.dateTime)}',
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
