import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta tickets_por_mes) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Ene');
                  case 1:
                    return Text('Feb');
                  case 2:
                    return Text('Mar');
                  case 3:
                    return Text('Abr');
                  case 4:
                    return Text('May');
                  case 5:
                    return Text('Jun');
                  case 6:
                    return Text('Jul');
                  case 7:
                    return Text('Ago');
                  case 8:
                    return Text('Sep');
                  case 9:
                    return Text('Oct');
                  case 10:
                    return Text('Nov');
                  case 11:
                    return Text('Dic');
                  default:
                    return Text('');
                }
            },
          ),
          ),
          
          
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _getBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 1.5,
            color: Colors.amber,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
