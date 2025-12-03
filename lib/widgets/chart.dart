import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';

class LineChartSample2 extends StatefulWidget {
  final List<double> salesData;

  const LineChartSample2({
    super.key,
    required this.salesData,
  });

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(showAvg ? avgData() : mainData()),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () => setState(() => showAvg = !showAvg),
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    final points = widget.salesData.isNotEmpty
        ? widget.salesData
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList()
        : [const FlSpot(0, 0)];

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => const FlLine(
          color: AppColors.mainGridLineColor,
          strokeWidth: 1,
        ),
      ),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color(0xff37434d)),
      ),
      minX: 0,
      maxX: (points.length - 1).toDouble(),
      minY: 0,
      maxY: (widget.salesData.isEmpty
          ? 10
          : widget.salesData.reduce((a, b) => a > b ? a : b) + 5),
      lineBarsData: [
        LineChartBarData(
          spots: points,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors.map((c) => c.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    final avg = widget.salesData.isNotEmpty
        ? widget.salesData.reduce((a, b) => a + b) / widget.salesData.length
        : 0.0;

    final points = widget.salesData.isNotEmpty
        ? widget.salesData
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), avg))
            .toList()
        : [const FlSpot(0, 0)];

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: Color(0xff37434d),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => const FlLine(
          color: Color(0xff37434d),
          strokeWidth: 1,
        ),
      ),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color(0xff37434d)),
      ),
      minX: 0,
      maxX: (points.length - 1).toDouble(),
      minY: 0,
      maxY: avg + 5,
      lineBarsData: [
        LineChartBarData(
          spots: points,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
