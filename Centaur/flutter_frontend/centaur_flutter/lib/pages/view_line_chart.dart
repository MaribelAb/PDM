import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ViewLineChart extends StatefulWidget {
  @override
  State<ViewLineChart> createState() => _ViewLineChartState();
}

class _ViewLineChartState extends State<ViewLineChart> {
  String selectedMonth = DateFormat('MMMM', 'es_ES').format(DateTime.now());
  List<FlSpot> spots = [];
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
        spots = _getOpenTicketsCountByDay(_tickets, DateTime.now().month);
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los tickets (codigo): $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<FlSpot> _getOpenTicketsCountByDay(List<Ticket> tickets, int month) {
    Map<int, int> ticketsCountByDay = {};

    for (int i = 1; i <= 31; i++) {
      ticketsCountByDay[i] = 0;
    }

    for (var ticket in tickets) {
      if (ticket.estado == 'abierto' && ticket.fecha_creacion?.month == month) {
        int day = ticket.fecha_creacion!.day;
        ticketsCountByDay[day] = (ticketsCountByDay[day] ?? 0) + 1;
      }
    }

    return ticketsCountByDay.entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.toDouble());
    }).toList();
  }

  void _onMonthChanged(String? newMonth) {
    if (newMonth != null) {
      setState(() {
        selectedMonth = newMonth;
        int monthIndex = DateFormat('MMMM', 'es_ES').parse(newMonth).month;
        spots = _getOpenTicketsCountByDay(_tickets, monthIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = List.generate(12, (index) => DateFormat('MMMM', 'es_ES').format(DateTime(2022, index + 1)));

    return Scaffold(
     
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Center(child: Text('Tickets Abiertos por Mes'),),
                DropdownButton<String>(
                  value: selectedMonth,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: _onMonthChanged,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LineChart(
                      LineChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                            axisNameWidget: Text('Tickets abiertos este mes'),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: Colors.amber,
                            barWidth: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}