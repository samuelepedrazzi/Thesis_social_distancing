import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tesi/global.dart' as globals;

class DistanceChart extends StatelessWidget {
  const DistanceChart({
    Key key,
    @required List<double> barValues,
  })  : _barValues = barValues,
        super(key: key);

  final List<double> _barValues;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 230,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            margin: 10.0,
          ),
          leftTitles: SideTitles(
              getTextStyles: (value) {
                return TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: Color(globals.textColor),
                );
              },
              margin: 10,
              showTitles: true,
              getTitles: (value) {
                if (value == 0) {
                  return '';
                } else if (value % 50 == 0) {
                  return '${value ~/ 1}';
                }
                return '';
              }),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _barValues
            .asMap()
            .map((key, value) => MapEntry(
                key,
                BarChartGroupData(
                  x: key,
                  barRods: [
                    BarChartRodData(
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        y: (value + 25 > 210 ? 210 : value + 25),
                        colors: globals.lightTheme == true
                            ? [Color(0xffd9d9d9)]
                            : [Color(0xff565656)],
                      ),
                      y: (value > 200 ? 200 : value),
                      colors: (value > globals.tresholdDistance
                          ? [Color(globals.textColor)]
                          : [Colors.red]),
                    ),
                  ],
                )))
            .values
            .toList(),
      ),
    );
  }
}
