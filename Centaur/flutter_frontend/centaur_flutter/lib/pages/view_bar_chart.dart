import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewBarChart extends StatefulWidget {
  @override
  State<ViewBarChart> createState() => _ViewBarChartState();
}

class _ViewBarChartState extends State<ViewBarChart> {
  List<Ticket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      List<Ticket> tickets = await getTickets(); 
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los tickets (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<int, int> _getTicketsPerMonth() {
    Map<int, int> ticketsPerMonth = {};
    for (int i = 0; i < 12; i++) {
      ticketsPerMonth[i] = 0;
    }

    for (var ticket in _tickets) {
      if (ticket.fecha_creacion != null) {
        int month = ticket.fecha_creacion!.month - 1;
        ticketsPerMonth[month] = (ticketsPerMonth[month] ?? 0) + 1;
      }
    }

    return ticketsPerMonth;
  }

  List<BarChartGroupData> _getBarGroups(Map<int, int> ticketsPerMonth) {
    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: ticketsPerMonth[index]?.toDouble() ?? 0,
            color: Colors.amber,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    Map<int, int> ticketsPerMonth = _getTicketsPerMonth();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: ticketsPerMonth.values.isEmpty ? 0 : (ticketsPerMonth.values.reduce((a, b) => a > b ? a : b)).toDouble(),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            axisNameWidget: Text('Tickets creados por mes'),
          ),
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
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _getBarGroups(ticketsPerMonth),
      ),
    );
  }
}
