import 'package:fitness_tracker/components/heat_map.dart';
import 'package:fitness_tracker/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Analytics Dashboard"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Your Progress",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: analyticsCard(
                    "Workouts",
                    value.getTotalWorkouts().toString(),
                    Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: analyticsCard(
                    "Exercises",
                    value.getTotalExercises().toString(),
                    Icons.list_alt,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: analyticsCard(
                    "Completed",
                    value.getCompletedExercises().toString(),
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: analyticsCard(
                    "Progress",
                    "${(value.getCompletionPercentage() * 100).toStringAsFixed(0)}%",
                    Icons.trending_up,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              "Completion Rate",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: value.getCompletionPercentage(),
              minHeight: 12,
            ),

            const SizedBox(height: 25),

            Text(
              "Activity Heatmap",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            MyHeatMap(
              datasets: value.heatMapDataSets,
              startDateYYYYDDMM: value.getStartDate(),
            ),
          ],
        ),
      ),
    );
  }

  Widget analyticsCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}