import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:welcomepage/constants.dart';

class User {
  final String nomPrenom;

  User({required this.nomPrenom});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(nomPrenom: json['nomPrenom']);
  }
}

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<User> users = [];

  Future<void> getUsers() async {
    try {
      var response = await http.get(Uri.parse(endpoint + 'Messagerie/index.php'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          users = jsonResponse.map((item) => User.fromJson(item)).toList();
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Erreur'),
            content: Text('Une erreur s\'est produite lors de la récupération des utilisateurs.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Une erreur s\'est produite lors de la récupération des utilisateurs.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des utilisateurs'),
        backgroundColor: Colors.blue[400],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(users[index].nomPrenom),
          );
        },
      ),
    );
  }
}
