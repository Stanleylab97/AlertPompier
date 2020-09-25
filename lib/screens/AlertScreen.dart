import 'dart:convert';
import 'dart:io';
import 'package:alert/config/NetworkHandler.dart';
import 'package:alert/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'BottomNavScreen.dart';
import 'package:geolocator/geolocator.dart';

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreentate createState() => _AlertScreentate();
}

class _AlertScreentate extends State<AlertScreen> {
  final _globalkey = GlobalKey<FormState>();
  double lat, lon;
  final networkHandler = NetworkHandler();
  bool circular = false;
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  List _types = ["Incendit", "Accident", "Autre"];
  String _typeValue;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    final geoposition =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = geoposition.latitude;
      lon = geoposition.longitude;
    });
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
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
      appBar: CustomAppBar(),
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            chooseTypeField(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (_globalkey.currentState.validate()) {
                  Map<String, String> data = {
                    "lat": lat.toString(),
                    "lon": lon.toString(),
                    "typeSin": _typeValue,
                    "consulted": false.toString(),
                  };

                  var imageResponse = await networkHandler.sendSinistre(
                      "/sinisters/create", _imageFile.path, data);
                  if (imageResponse.statusCode == 201) {
                    setState(() {
                      circular = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BottomNavScreen()),
                        (route) => false);
                  } else {
                    setState(() {
                      circular = false;
                      showError("Erreur inattendue");
                      /* Map<String,String> output = json.decode(imageResponse.body);
                      showError(output['message']); */
                    });
                  }
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator()
                        : Text(
                            "Signaler le sinistre",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 130.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/images/sinistres/defaultsinistre.jpg")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 30.0,
          right: 5.0,
          child: InkWell(
            onTap: () {
              takePhoto(ImageSource.camera);
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.red,
              size: 60.0,
            ),
          ),
        ),
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget chooseTypeField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(25.0)),
        child: DropdownButton(
            hint: Text("Type de sinistre"),
            dropdownColor: Colors.white,
            elevation: 5,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 36.0,
            isExpanded: true,
            value: _typeValue,
            style: TextStyle(color: Colors.black, fontSize: 18.0),
            onChanged: (value) {
              setState(() {
                _typeValue = value;
              });
            },
            items: _types.map((e) {
              return DropdownMenuItem(
                child: Text(e),
                value: e,
              );
            }).toList()),
      ),
    );
  }
}
