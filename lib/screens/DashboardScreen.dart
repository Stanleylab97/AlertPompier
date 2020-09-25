import 'package:alert/config/palette.dart';
import 'package:alert/config/styles.dart';
import 'package:alert/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alert/data/data.dart';
import 'AlertScreen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CustomAppBar(),
        body: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: <Widget>[
            _buildHeader(screenHeight,context),
            _buildKindEmergency(screenHeight),
            _buildMessage(screenHeight)
          ],
        ));
  }
}

SliverToBoxAdapter _buildHeader(double screenHeight, BuildContext context) {
  return SliverToBoxAdapter(
      child: Container(
    padding: const EdgeInsets.all(20.0),
    decoration: BoxDecoration(
        color: Palette.primaryColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              "Urgence",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(height: screenHeight * 0.03),
        Column(
          children: <Widget>[
            Text('Vous êtes témoin d\'un sinistre ?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: screenHeight * 0.01),
            Text(
                'Chaque seconde est précieuse. Alertez-nous immédiatement avec des détails par ici.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                )),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    onPressed: () {
                      launch("tel:911");
                    },
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    icon: const Icon(Icons.call),
                    label: Text("Appeler", style: Styles.buttonTextStyle),
                    textColor: Colors.white),
                FlatButton.icon(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => AlertScreen()));
                    },
                    color: Colors.green[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    icon: const Icon(Icons.notifications_active),
                    label: Text("Alertez-nous", style: Styles.buttonTextStyle),
                    textColor: Colors.white),
              ],
            )
          ],
        )
      ],
    ),
  ));
}

SliverToBoxAdapter _buildKindEmergency(double screenHeight) {
  return SliverToBoxAdapter(
    child: Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Types d'urgence",
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: sinistreCategories
                .map((e) => Column(
                      children: <Widget>[
                        Image.asset(
                          e.keys.first,
                          height: screenHeight * 0.12,
                          width: screenHeight * 0.12,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          e.values.first,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    ),
  );
}

SliverToBoxAdapter _buildMessage(double screenHeight) {
    return SliverToBoxAdapter(
      child: Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      padding: const EdgeInsets.all(10.0),
      height: screenHeight * 0.15,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFAD9FE4), Palette.primaryColor]),
              borderRadius: BorderRadius.circular(20.0)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                Image.asset('assets/images/casque.png'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text("Prêts pour vous servir",
                   style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height:screenHeight * 0.01),
                  Text("Ne paniquez pas. Nos casernes\n sont prêtes pour vous répondre.",
                   style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    ),
                    maxLines: 3,
                  )
                ],
                )
              ],
            ),
    )
    );
  }
