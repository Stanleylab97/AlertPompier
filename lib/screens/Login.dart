import 'dart:convert';

import 'package:alert/config/NetworkHandler.dart';
import 'package:alert/config/palette.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'BottomNavScreen.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool vis = true;
  String errorText;
  bool validate = false;
  bool circular = false;
  Logger log;
  final storage = new FlutterSecureStorage();

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        circular = true;
      });
      Map<String, String> data = {
        "email": _email.text.trim(),
        "password": _password.text.trim()
      };
      DataConnectionStatus status = await isConnected();
      if (status == DataConnectionStatus.connected) {
        var response = await networkHandler.post("/users/login", data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> output = json.decode(response.body);
          print(output['token']);
          await storage.write(key: "token", value: output["token"]);

          setState(() {
            validate = true;
            circular = false;
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavScreen(),
              ),
              (route) => false);
        } else {
          String output = json.decode(response.body);
          setState(() {
            validate = false;
            errorText = output;
            circular = false;
          });
        }
      }else{
        Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Vérifiez votre connexion internet")));
      }               
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  navigateToDashboard() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              height: 400,
              child: Image(
                image: AssetImage("assets/images/login.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        controller: _email,

                        validator: (input) {
                          if (input.isEmpty) return 'Enter Email';
                          if (!input.contains("@")) return "Email is Invalid";
                          return null;
                        },
                        decoration: InputDecoration(
                          errorText: validate ? null : errorText,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        //onSaved: (input) => _email = input
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _password,
                        validator: (input) {
                          if (input.length < 6)
                            return 'Provide Minimum 6 Character';
                          return null;
                        },
                        obscureText: vis,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                                vis ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                vis = !vis;
                              });
                            },
                          ),
                        ),
                        //onSaved: (input) => _password = input
                      ),
                    ),
                    SizedBox(height: 5),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: login,
                      child: circular
                          ? CircularProgressIndicator()
                          : Text('Connexion',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                      color: Palette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              child: Text(
                'Créer un compte ?',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              onTap: navigateToSignUp,
            )
          ],
        ),
      ),
    ));
  }

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update

  }
}
