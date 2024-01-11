import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:welcomepage/Dashboard.dart';
import 'package:welcomepage/component/progress.dart';
import 'package:http/http.dart' as http;
import 'package:welcomepage/loginkey.dart';
import 'package:welcomepage/mdp.dart';
import 'constants.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginPageState();
}
class user {
  final String nomprenom;
  final String email;


  user({required this.nomprenom, required this.email});
}

class _LoginPageState extends State<Loginpage> {
  List<user> users = [];
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  late String _email;
  TextEditingController txtemail = new TextEditingController();
  TextEditingController txtpwd = new TextEditingController();
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue,
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Column(
          // even space distribution
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Connexion",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/blu+.png",
                      ))),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              margin: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.065),
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Se connecter :",
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  TextFormField(
                    controller: txtemail,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.mail),
                      hintText: 'Entrer votre adresse e-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  TextField(
                    controller: txtpwd,
                    obscureText: hide,
                    decoration: InputDecoration(
                        hintText: "Mot de passe",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          icon: hide
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Mdp()));
                      },
                      child: Text("Mot de passe oublié?"),
                    ),
                  ),
                  Center(
                    child: isloading
                        ? circularProgress()
                        : ElevatedButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 60)),
                        onPressed: () {
                          _login();
                        },
                        child: Text("Se connecter")),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginkey()));
                      },
                      child: Text("Se connecter avec une clé "),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    try {
      String email = txtemail.text;
      String password = txtpwd.text;
      http.Response response = await http.post(
        Uri.parse(endpoint + "/Login.php"),
        body: json.encode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['code'] == 'success') {
          String userName = jsonData['data']['NomPrenom'] ??
              ''; // Vérification de nullité pour le nom d'utilisateur
          String userEmail = jsonData['data']['Email'] ??
              ''; // Vérification de nullité pour l'e-mail

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                userName: userName,
                userEmail: userEmail,
              ),
            ),
          );
        } else {
          // Gérer le cas où la connexion a échoué ou les informations d'identification sont invalides
        }
      } else {
        // Gérer les autres codes de statut HTTP si nécessaire
      }
    } catch (e) {
      // Gérer les erreurs pouvant survenir pendant la requête HTTP
      print('Erreur lors de la requête HTTP: $e');
      // Afficher un message d'erreur à l'utilisateur ou prendre d'autres mesures nécessaires
    }
  }
}