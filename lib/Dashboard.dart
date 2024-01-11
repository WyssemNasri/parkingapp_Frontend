import 'package:flutter/material.dart';
import 'package:welcomepage/addCar.dart';
import 'package:welcomepage/connexion.dart';
import 'package:welcomepage/appointment.dart';
import 'package:welcomepage/TableauxApp.dart';
import 'package:welcomepage/rating.dart';
import 'package:welcomepage/rendez-vous.dart';

import 'Aujourdhui.dart';

import 'FoundMatriculCar.dart';
import 'MonParking.dart';
import 'conversation.dart';
import 'foundcar.dart';
import 'home/login_db.dart';
import 'index.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  final String userName;
  final String userEmail;

  const Dashboard({Key? key, required this.userName, required this.userEmail})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              "assets/hethy.jpeg",
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
              },
              child: Icon(
                Icons.chat,
                color: Colors.blue,
              ),
            ),
            label: 'Conversation',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                   MaterialPageRoute(
                    builder: (context) =>
                        DashboardScreen(
                          userName: widget.userName
                        ),
                 ),
                );
              },
              child: Icon(
                Icons.dashboard,
                color: Colors.blue,
              ),
            ),
            label: 'Statistique',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                // Handle onTap for Réserver icon
                // Example: navigate to Réserver screen
              },
              child: Icon(
                Icons.calendar_today,
                color: Colors.blue,
              ),
            ),
            label: 'Réserver',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {

              },
              child: Icon(
                Icons.local_parking,
                color: Colors.blue,
              ),
            ),
            label: 'Trouver parking',
          ),

          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => OwnerCarsScreen(nomPrenom: widget.userName, // Remplacez par le nom et prénom du propriétaire
                ),
                ),
                );
              },
              child: Icon(
                Icons.car_crash,
                color: Colors.blue,
              ),
            ),
            label: 'Trouver Ma Voiture',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CarLocationScreen(userName: widget.userName, // Remplacez par le nom et prénom du propriétaire
                ),
                ),
                );
              },
              child: Icon(
                Icons.car_crash,
                color: Colors.blue,
              ),
            ),
            label: 'Trouver(Matricule)Voiture ',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RatingApp()),
                );
              },
              child: Icon(
                Icons.star,
                color: Colors.blue,
              ),
            ),
            label: 'Évaluation',
          ),
        ],
        iconSize: 33.0,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.userName),
              accountEmail: Text(widget.userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.local_parking,
                color: Colors.blue,
              ),
              title: Text("Mon Parking"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingInfoScreen(
                      nomPrenom: widget.userName, // Remplacez par le nom et prénom souhaité
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Icon(
                Icons.car_repair,
                color: Colors.blue,
              ),
              title: Text("Ajouter Une Voiture"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCarPage()),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Icon(
                Icons.update,
                color: Colors.blue,
              ),
              title: Text("Reservation en attente "),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RendezVousList()),
                );
              },
            ),
            SizedBox(
              height: 150,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.blue,
              ),
              title: Text('Se déconnecter'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Loginpage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
