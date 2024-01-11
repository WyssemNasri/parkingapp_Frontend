import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

import 'Dashboard.dart';
import 'constants.dart';

void main() {
  runApp(MaterialApp(
    home: Doct(),
  ));
}

class Doctor {
  final String name;
  final String specialty;
  final String rate;

  Doctor({required this.name, required this.specialty, required this.rate});
}

class Doct extends StatefulWidget {
  @override
  _DoctState createState() => _DoctState();
}

class _DoctState extends State<Doct> {
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();
  List<String> filterSpecialties = [];

  String? selectedSpecialty;

  @override
  void initState() {
    super.initState();
    fetchDoctors().then((doctorsList) {
      setState(() {
        doctors = doctorsList;
        filteredDoctors = doctorsList;
        filterSpecialties = doctors
            .map((doctor) => doctor.specialty)
            .toSet()
            .toList();
      });
    });
  }

  Future<List<Doctor>> fetchDoctors() async {
    final apiUrl = endpoint + '/Users/liste_des_docteur.php';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData); // Print response body for debugging

      if (jsonData['code'] == 'success' && jsonData.containsKey('data')) {
        List<Doctor> doctors = [];

        for (var doctorData in jsonData['data']) {
          if (doctorData is Map &&
              doctorData.containsKey('nomPrenom') &&
              doctorData.containsKey('specialite') &&
              doctorData.containsKey('rate')) {
            Doctor doctor = Doctor(
              name: doctorData['nomPrenom'].toString(),
              specialty: doctorData['specialite'].toString(),
              rate: doctorData['rate'].toString(),
            );
            doctors.add(doctor);
          }
        }

        return doctors;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception(
          'Erreur lors de l\'appel à l\'API : ${response.reasonPhrase}');
    }
  }

  void filterDoctors() {
    final String searchText = searchController.text.toLowerCase();

    setState(() {
      filteredDoctors = doctors.where((doctor) {
        final bool nameMatch = doctor.name.toLowerCase().contains(searchText);
        final bool specialtyMatch =
            selectedSpecialty == null || doctor.specialty == selectedSpecialty;
        return nameMatch && specialtyMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liste des Médecins',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Liste des Médecins'),
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) => filterDoctors(),
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            DropdownButton<String>(
              value: selectedSpecialty,
              hint: Text('Select a speciality'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSpecialty = newValue;
                  filterDoctors();
                });
              },
              items: filterSpecialties.map((String specialty) {
                return DropdownMenuItem<String>(
                  value: specialty,
                  child: Text(specialty),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RendezVousScreen(
                            doctor: filteredDoctors[index],
                          ),
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
                            filteredDoctors[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Specialty: ${filteredDoctors[index].specialty}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Rate: ${filteredDoctors[index].rate}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RendezVousScreen extends StatefulWidget {
  final Doctor doctor;

  RendezVousScreen({required this.doctor});

  @override
  _RendezVousScreenState createState() => _RendezVousScreenState();
}

class _RendezVousScreenState extends State<RendezVousScreen> {
  ValueNotifier<DateTime> _selectedDate =
  ValueNotifier<DateTime>(DateTime.now());
  DateTime _firstDay = DateTime(2023, 5, 1);
  DateTime _lastDay = DateTime(2023, 12, 29);
  TimeOfDay _selectedTime = TimeOfDay.now();

  TextEditingController _keyController = TextEditingController();
  TextEditingController _selectedDateController = TextEditingController();
  TextEditingController _selectedTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rendez-vous avec  ${widget.doctor.name}'),
      ),
      body: SingleChildScrollView(
        child: Container(        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Médecin: ${widget.doctor.name}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Spécialité: ${widget.doctor.specialty}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Choisir une date :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            TableCalendar(
              focusedDay: _selectedDate.value,
              firstDay: _firstDay,
              lastDay: _lastDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate.value, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate.value = selectedDay;
                  _selectedDateController.text = selectedDay.toString().split(' ')[0];
                });
              },
            ),
            SizedBox(height: 18.0),
            Text(
              'Date choisie: ${_selectedDateController.text}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 18.0),
            ElevatedButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 140),
              ),
              onPressed: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (selectedTime != null) {
                  setState(() {
                    _selectedTime = selectedTime;
                    _selectedTimeController.text = selectedTime.format(context);
                  });
                }
              },
              child: Text('    horaire        '),
            ),
            SizedBox(height: 30.0),
            Text(
              'Entrer votre clé de sécurité:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _keyController,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  labelText: 'Clé de sécurité ',
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            SizedBox(height: 30.0),

            ElevatedButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 155),
              ),
              onPressed: () {
                _reserver();
                final DateTime selectedDateTime = DateTime(
                  _selectedDate.value.year,
                  _selectedDate.value.month,
                  _selectedDate.value.day,
                  _selectedTime.hour,
                  _selectedTime.minute,
                );
                print('Selected DateTime: $selectedDateTime');
              },
              child: Text('Confirmer'),
            ),

          ],
        ),
      ),),
      resizeToAvoidBottomInset: false,

    );
  }

void _reserver() async {
  String doctor_name = widget.doctor.name;
  String key= _keyController.text;
  String date = _selectedDateController.text;
  String heure = _selectedTimeController.text;

  http.Response response = await http.post(
    Uri.parse(endpoint + "/Rendezvous/reserver.php"),
    body: json.encode(
      {"patient_key": key,"doctor_name":doctor_name, "date": date, "time":heure},
    ),
  );
  if (response.statusCode == 200) {

    final jsonData = json.decode(response.body);
    print(jsonData);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard(userName: '', userEmail: '',)),
    );
  }

}
}

