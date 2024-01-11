import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomprenomController = TextEditingController();
  final TextEditingController _specialiteController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nomParkingController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _maxSizeController = TextEditingController();

  String type1 = "Chauffeur";
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
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 40),
              child: Text(
                "Inscription",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.17,
              ),
              width: double.infinity,
              height: 750,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "S'inscrire :",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 13),
                  TextField(
                    controller: _nomprenomController,
                    decoration: InputDecoration(
                      hintText: "Nom & Prénom / Société",
                      suffixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 13),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Etablissement",
                      suffixIcon: Icon(Icons.house),
                    ),
                  ),
                  SizedBox(height: 13),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Numéro de téléphone",
                      suffixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 13),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Adresse Email",
                      suffixIcon: Icon(Icons.mail),
                    ),
                  ),
                  SizedBox(height: 13),
                  TextField(
                    controller: _passwordController,
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
                      ),
                    ),
                  ),
                  SizedBox(height: 13),
                  RadioListTile(
                    value: "Chauffeur",
                    groupValue: type1,
                    onChanged: (value) {
                      setState(() {
                        type1 = value.toString();
                      });
                    },
                    title: Text("Chauffeur"),
                  ),
                  RadioListTile(
                    value: "Propriétaire du parking",
                    groupValue: type1,
                    onChanged: (value) {
                      setState(() {
                        type1 = value.toString();
                      });
                    },
                    title: Text("Propriétaire du parking"),
                  ),
                  SizedBox(height: 13),
                  if (type1 == "Propriétaire du parking") ...[
                    TextField(
                      controller: _nomParkingController,
                      decoration: InputDecoration(
                        hintText: "Nom du Parking",
                        suffixIcon: Icon(Icons.local_parking),
                      ),
                    ),
                    SizedBox(height: 13),
                    TextField(
                      controller: _villeController,
                      decoration: InputDecoration(
                        hintText: "Ville",
                        suffixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    SizedBox(height: 13),
                    TextField(
                      controller: _maxSizeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Taille maximale",
                        suffixIcon: Icon(Icons.space_bar),
                      ),
                    ),
                    SizedBox(height: 13),
                  ],
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 80,
                        ),
                      ),
                      onPressed: () {
                        _signup();
                      },
                      child: Text(
                        ("Envoyer"),
                        style: TextStyle(fontSize: 20),
                      ),
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

  void _signup() async {
    String numero = _phoneController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String nomprenom = _nomprenomController.text;
    String privilege = type1;

    // Création des données à envoyer
    Map<String, dynamic> data = {
      "nomprenom": nomprenom,
      "email": email,
      "password": password,
      "privilege  ": privilege,
      "numero": numero,
    };

    if (privilege == "Propriétaire du parking") {
      // Ajouter des données supplémentaires pour le propriétaire du parking
      String nomParking = _nomParkingController.text;
      String ville = _villeController.text;
      String maxSize = _maxSizeController.text;
      data["NomParking"] = nomParking;
      data["adresse"] = ville;
      data["max_size"] = maxSize;
    }

    // Envoyer les données à l'API
    http.Response response = await http.post(
      Uri.parse(endpoint +"Inscription/vendor/phpmailer/phpmailer/Nouveau_Inscription.php"), // Remplacez ceci par l'URL de votre API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Redirection vers la page de connexion après une inscription réussie
      Navigator.pop(context);
    } else {
      // Affichage d'un message d'erreur en cas d'échec de l'inscription
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Échec de l'inscription. Veuillez réessayer."),
        ),
      );
    }
  }
}
