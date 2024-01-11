import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'Aujourdhui.dart';
import 'constants.dart';

class Appointment {
  final String id;
  final String patientName;
  final DateTime dateTime;
  bool confirmed;
  final String time;

  Appointment({
    required this.id,
    required this.patientName,
    required this.dateTime,
    required this.confirmed,
    required this.time,
  });
}

class RendezVousList extends StatefulWidget {
  const RendezVousList({Key? key}) : super(key: key);

  @override
  _RendezVousListState createState() => _RendezVousListState();
}

class _RendezVousListState extends State<RendezVousList> {
  List<Appointment> appointments = [];
  TextEditingController doctorKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch appointments when the widget is initialized
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final String doctorKey = doctorKeyController.text;

    http.Response response = await http.post(
      Uri.parse(endpoint + "/Rendezvous/docteur_redezvous.php"),
      body: json.encode(
        {'doctor_key': doctorKey},
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['result'] == 'success' && jsonData.containsKey('message')) {
        final data = jsonData['message'];

        final appointmentsList = data.map<Appointment>((appointmentJson) {
          return Appointment(
            id: appointmentJson['id'].toString(),
            patientName: appointmentJson['patient_name'].toString(),
            dateTime: DateTime.parse(appointmentJson['date'].toString()),
            confirmed: false,
            time: appointmentJson['time'].toString(),
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
      print("ok");
    }
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> acceptAppointment(String id) async {
    final response = await http.post(
      Uri.parse(endpoint + "Rendezvous/accept.php"),
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['result'] == 'success') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Appointment accepted'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  fetchAppointments();
                },
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
            content: Text('Failed to accept appointment'),
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
          content: Text('Failed to accept appointment'),
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

  Future<void> rejectAppointment(String id) async {
    final response = await http.post(
      Uri.parse(endpoint + "/Rendezvous/refuse.php"),
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['result'] == 'success') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Appointment rejected'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  fetchAppointments();
                },
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
            content: Text('Failed to reject appointment'),
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
          content: Text('Failed to reject appointment'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des rendez-vous'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: doctorKeyController,
              decoration: InputDecoration(
                labelText: 'Clé du médecin',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
            ),
            onPressed: fetchAppointments,
            child: Text('Envoyer'),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];

                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${appointment.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        appointment.patientName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Heure: ${appointment.time}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Date: ${formatDate(appointment.dateTime.toString())}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => acceptAppointment(appointment.id),
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () => rejectAppointment(appointment.id),
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
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

class AutreInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autre Interface'),
      ),
      body: Center(
        child: Text('Ceci est une autre interface.'),
      ),
    );
  }
}
