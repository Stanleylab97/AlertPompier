import 'dart:convert';

import 'package:alert/config/NetworkHandler.dart';
import 'package:alert/config/palette.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
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
          Map<String, String> output = json.decode(response.body);
          setState(() {
            validate = false;
            //errorText = output['status'];
            circular = false;
          });
        }
      } else {
        setState(() {
          circular = false;
        });
        Flushbar(
            title: "Hey Ninja",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundColor: Colors.red,
            boxShadows: [
              BoxShadow(
                  color: Colors.blue[800],
                  offset: Offset(0.0, 2.0),
                  blurRadius: 3.0)
            ],
            backgroundGradient:
                LinearGradient(colors: [Colors.blueGrey, Colors.black]),
            isDismissible: false,
            duration: Duration(seconds: 4),
            icon: Icon(
              Icons.info_outline,
              color: Colors.greenAccent,
            ),
            mainButton: FlatButton(
              onPressed: () {},
              child: Text(
                "BAD",
                style: TextStyle(color: Colors.amber),
              ),
            ),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor: Colors.blueGrey,
            titleText: Text(
              "Connexion impossible",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.yellow[600],
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: Text(
              "Vérifiez votre connexion internet!",
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.green,
                  fontFamily: "ShadowsIntoLightTwo"),
            ));
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
