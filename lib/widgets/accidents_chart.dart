import 'package:alert/config/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AccidentChart extends StatelessWidget {
  final List<int> weeksAccidents;
  const AccidentChart({@required this.weeksAccidents});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 350.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Evolution hebdomadaire des accidents",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                child: BarChart(BarChartData(
              maxY: 30,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                      margin: 10.0,
                      showTitles: true,
                      textStyle: Styles.chartLabelsTextStyle,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Lundi';
                          case 1:
                            return 'Mardi';
                          case 2:
                            return 'Mercredi';
                          case 3:
                            return 'Jeudi';
                          case 4:
                            return 'Vendredi';
                          case 5:
                            return 'Samedi';
                          case 6:
                            return 'Dimanche';

                          default:
                            return '';
                        }
                      }),
                  leftTitles: SideTitles(
                      margin: 10.0,
                      showTitles: true,
                      textStyle: Styles.chartLabelsTextStyle,
                      getTitles: (value) {
                        if (value == 0) {
                          return '0';
                        } else if (value % 3 == 0) {
                          return '${value ~/ 3 * 5}K';
                        }

                        return '';
                      })),
              gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 3 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.black12,
                        strokeWidth: 1.0,
                        dashArray: [5],
                      )),
              borderData: FlBorderData(show: false),
              barGroups: weeksAccidents
                  .asMap()
                  .map((key, value) => MapEntry(
                      key,
                      BarChartGroupData(x: key, barRods: [
                        BarChartRodData(y: value.toDouble(), color: Colors.red),
                      ])))
                  .values
                  .toList(),
            )))
          ],
        ));
  }
}
