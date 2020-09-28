import 'package:alert/config/NetworkHandler.dart';
import 'package:alert/config/palette.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'BottomNavScreen.dart';
import 'package:flushbar/flushbar.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tel = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var log = Logger();
  bool vis = true;
  bool visc = true;
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();

  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    super.initState();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
       setState(() {
        circular = true;
      });
      
      Map<String, String> data = {
        "email": _email.text.trim(),
        "tel": _tel.text.trim(),
        "method": "local",
        "password": _password.text.trim()
      };
      BuildContext context;

      try {
        DataConnectionStatus status = await isConnected();
        if (status == DataConnectionStatus.connected) {
          var response = await networkHandler.post("/users/register", data);
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
            
            Flushbar(
              message:
                  "Une erreur s'est produite",
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              duration: Duration(seconds: 3),
              leftBarIndicatorColor: Colors.blue[300],
            )..show(context);
          }
        } else {
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
            ),
          );
        }
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Errreur'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 350,
              child: Image(
                image: AssetImage("assets/images/signup.jpg"),
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
                        validator: (inputEmail) {
                          if (inputEmail.isEmpty) return 'Entrez votre e-mail';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        //onSaved: (inputEmail) => _email = inputEmail
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _tel,
                        validator: (inputTel) {
                          if (inputTel.isEmpty) return 'Tel';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: Icon(Icons.phone),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        //onSaved: (input) => _tel = input
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: _password,
                        validator: (inputPass) {
                          if (inputPass.length < 6)
                            return 'Saisissez au moins 6 caractères';
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
                        //onSaved: (inputPass) => _password = inputPass
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        // ignore: missing_return
                        validator: (inputConf) {
                          if (inputConf.isEmpty)
                            return 'Veuillez confirmer le mot de passe';

                          if (inputConf != _password.text)
                            return 'Mot de passe non conforme';

                          return null;
                        },
                        obscureText: visc,
                        decoration: InputDecoration(
                          labelText: 'Confirmation mot de passe',
                          prefixIcon: Icon(Icons.lock),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                                visc ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                visc = !visc;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                      onPressed: signUp,
                      child: circular
                          ? CircularProgressIndicator()
                          : Text('Enregistrer',
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
