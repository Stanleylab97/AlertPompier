import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        
        child: Column(
          children: <Widget>[
            Flexible(
                child: Row(
              children: <Widget>[
                _buildStatCard('Total sinistres', '203', Colors.blue),
                _buildStatCard('Vies sauvées', '103', Colors.green),

              ],
            )),
            Flexible(
                child: Row(
              children: <Widget>[
                _buildStatCard('Cas critiques', '61', Colors.orange),
                _buildStatCard('Morts', '39', Colors.red),
              ],
            ))
          ],
        ));
  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                count,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )
            ]),
      ),
    );
  }
}
