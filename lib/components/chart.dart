import 'package:fl_chart/fl_chart.dart';
//import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:skywalker/components/pad.dart';

class Chart extends StatefulWidget {
  Chart({
    super.key,
    required this.spots,
    this.title = 'Line Chart Sample',
    this.icon = Icons.show_chart,
    this.color = const Color(0xff23b6e6),
    this.color2 = const Color(0xff02d39a),
  }) {
    var v = HSLColor.fromColor(color);
    color2 = v.withHue((v.hue - 40) % 360).toColor();
  }
  final List<FlSpot> spots;
  final String title;
  final IconData icon;
  final Color color;
  Color color2;
  @override
  State<Chart> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return pady(
      Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 60,
              bottom: 12,
            ),
            child: LineChart(mainData()),
          ),
          padxbig(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.icon, color: widget.color, size: 28),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: const Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 20,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),

      lineBarsData: [
        LineChartBarData(
          spots: widget.spots,
          isCurved: true,
          gradient: LinearGradient(colors: [widget.color, widget.color2]),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                widget.color.withValues(alpha: 0.3),
                widget.color2.withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
