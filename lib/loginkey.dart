import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'Dashboard.dart';
import 'constants.dart';
class Loginkey extends StatefulWidget {
  const Loginkey({Key? key}) : super(key: key);

  @override
  State<Loginkey> createState() => _LoginkeyPageState();
}

class _LoginkeyPageState extends State<Loginkey> {
  TextEditingController txtcle = new TextEditingController();
  final TextEditingController _cleController = TextEditingController();

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
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // even space distribution
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[


            Center(

              child: Text("Connecter avec une clé", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),),
            ), SizedBox(
              height: 40,
            ),


            Container(

              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/key.png")

                  )
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              margin: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.08),
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Entrer la clé :", style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),),

                  SizedBox(height: 40,),
                  TextField(
                    controller: txtcle,
                    decoration: InputDecoration(
                        hintText: "Votre cle",
                        suffixIcon: Icon(Icons.key)


                    ),
                  ),
                  SizedBox(height: 40,),
                  Center(
                    child: ElevatedButton(

                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)
                            ),
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 60)
                        ),
                        onPressed: () {
                          _loginkey();
                        }, child: Text("Connecter")),

                  ),
                ],),),
          ],
        ),),
    );
  }

  void _loginkey() async {
    String cle = txtcle.text;
    http.Response response = await http.post(
      Uri.parse(endpoint + "loginkey.php"),
      body: json.encode(
        {"cle": cle},
      ),
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
            builder: (context) =>
                Dashboard(
                  userName: userName,
                  userEmail: userEmail,
                ),
          ),
        );
      }
    }
  }
}