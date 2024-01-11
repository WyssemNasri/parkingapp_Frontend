import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:welcomepage/constants.dart';
class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController _nomPrenomController = TextEditingController();

  void _valider() async {
    String nomPrenom = _nomPrenomController.text;
    if (nomPrenom.isNotEmpty) {
      var response = await http.post(
        Uri.parse(endpoint+'Messagerie/message.php'),
        body: {'nomPrenom': nomPrenom},
      );

      if (response.statusCode == 200) {
        // Rediriger vers la page index.php
        Navigator.pushReplacementNamed(context, '/index');
      } else {
        // Afficher un message d'erreur
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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
            );
          },
        );
      }
    } else {
      // Afficher un message d'erreur
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Veuillez entrer votre pseudo'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace de connexion'),
        backgroundColor: Colors.blue[400],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nomPrenomController,
                decoration: InputDecoration(
                  labelText: 'Nom / Prénom',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _valider,
                child: Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
