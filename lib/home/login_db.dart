import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:welcomepage/home/config.dart';
import 'package:welcomepage/loginUsers.dart';
Future<bool> loginUsers  (
    String Email,String Password, BuildContext context) async {

String url = path_api + "Login.php?email=" +Email + "&password" + Password ;
http.Response response = await  http.get(url as Uri);
if (jsonDecode(response.body)["Password"]== "azerty" ){
Map arr = jsonDecode(response.body)["message"];
SharedPreferences sh = await  SharedPreferences.getInstance();
sh.setString(G_use_Email,arr["Email"]);
sh.setString(G_use_pwd,arr["Password"]);
Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
print("success");
return true;


} else{
  print("failer");
  return false;

}

}
