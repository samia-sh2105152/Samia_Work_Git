import 'package:fitness_tracker/datetime/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYDDMM;
  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYDDMM,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        datasets: datasets,
        startDate: createDateTimeObject(startDateYYYYDDMM),
        endDate: DateTime.now(),
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {1: Colors.green},
      ),
    );
  }
}
