import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home Page"),
        backgroundColor: Color.fromRGBO(19, 150, 145, 1.0),
      ),
      body: Center(child: Text("Welcome To Home Page",style: TextStyle(fontSize: 30),),),
    );
  }
}
