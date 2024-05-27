import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            axisNameWidget: Text('Tickets abiertos este mes')
          ),
        ),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 10),
              FlSpot(3, 7),
              FlSpot(4, 12),
            ],
            isCurved: true,
            color: Colors.amber,
            barWidth: 5,
          ),
        ],
      ),
    );
  }
}