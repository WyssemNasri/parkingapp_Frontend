import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:welcomepage/constants.dart';

class UserModel {
  final String name;

  UserModel({required this.name});
}

class ParametersInterface extends StatefulWidget {
  @override
  _ParametersInterfaceState createState() => _ParametersInterfaceState();
}

class _ParametersInterfaceState extends State<ParametersInterface> {
  UserModel? _user;
  bool _checkNotifications = true;
  bool _messageOption = true;
  bool _callOption = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final name = jsonData['name'];

      setState(() {
        _user = UserModel(name: name);
      });
    } else {
      print('Failed to fetch user data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramétres'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Nom Utilisateur '),
            trailing: _user != null ? Text(_user!.name) : Text('Loading...'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            trailing: Switch(
              value: _checkNotifications,
              onChanged: (value) {
                setState(() {
                  _checkNotifications = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Option des messages'),
            trailing: Switch(
              value: _messageOption,
              onChanged: (value) {
                setState(() {
                  _messageOption = value;
                });
              },
            ),
          ),

        ],
      ),
    );
  }
}
