import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:welcomepage/constants.dart';
import 'package:http/http.dart' as http;

class Mdp extends StatefulWidget {
  const Mdp({Key? key}) : super(key: key);

  @override
  State<Mdp> createState() => _MdpPageState();
}

class _MdpPageState extends State<Mdp> {
  TextEditingController txtemail = new TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
        child: Column(
          // even space distribution
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Réinitialiser le mot de passe",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image:
                  DecorationImage(image: AssetImage("assets/reset.png"))),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              width: double.infinity,
              height: 550,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Entrez votre adresse e-mail ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Adresse Email ",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: txtemail,
                    decoration: InputDecoration(
                        hintText: "nasriwissam6@gmail.com",
                        suffixIcon: Icon(Icons.mail)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 60)),
                        onPressed: () {
                          _PasswordReset();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                title: Text(
                                  'Mail envoyé',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                    'Une instruction de réinitialisation est envoyée à votre adresse e-mail',
                                    style: TextStyle(fontSize: 18)),
                                actions: [
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          _PasswordReset();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("Envoyer")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _PasswordReset() async {
    String email = txtemail.text;

    http.Response response = await http.post(
      Uri.parse(endpoint + "resetpassword/vendor/phpmailer/phpmailer/send.php"),
      body: json.encode(
        {"email": email},
      ),
    );
  }
}
