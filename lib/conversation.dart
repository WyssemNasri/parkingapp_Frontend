import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController _nomPrenomController = TextEditingController();
  List<String> _users = [];
  List<String> _messages = [];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    var response = await http.get(Uri.parse(endpoint + '/messagerie/index.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<String> users = data.map((user) => user['nomPrenom'] as String).toList();
      setState(() {
        _users = users;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Échec de la récupération des utilisateurs'),
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

  Future<void> sendMessage(String message) async {
    var response = await http.post(
      Uri.parse(endpoint + '/messagerie/message.php'),
      body: {'message': message},
    );

    if (response.statusCode == 200) {
      fetchMessages();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Échec de l envoi du message'),
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

  Future<void> fetchMessages() async {
    var response = await http.get(Uri.parse(endpoint + '/messagerie/message.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<String> messages = data.map((message) => message['message'] as String).toList();
      setState(() {
        _messages = messages;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Échec de la récupération des messages'),
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

  Future<void> connectUser() async {
    String nomPrenom = _nomPrenomController.text;
    if (nomPrenom.isNotEmpty) {
      var response = await http.post(
        Uri.parse(endpoint + '/messagerie/connexion.php'),
        body: {'nomPrenom': nomPrenom},
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoggedIn = true;
        });
        fetchMessages();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Erreur'),
            content: Text('Aucun utilisateur trouvé'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez fournir le nom/prénom'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isLoggedIn)
              TextFormField(
                controller: _nomPrenomController,
                decoration: InputDecoration(
                  labelText: 'Nom/Prénom',
                ),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoggedIn ? null : connectUser,
              child: Text('Se connecter'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_users[index]),
                  );
                },
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
            if (_isLoggedIn)
              TextFormField(
                onFieldSubmitted: sendMessage,
                decoration: InputDecoration(
                  labelText: 'Message',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
