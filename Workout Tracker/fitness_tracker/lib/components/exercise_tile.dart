import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.15)
            : const Color.fromARGB(255, 222, 207, 224),

        borderRadius: BorderRadius.circular(16),
      ),

      child: ListTile(
        title: Text(
          exerciseName,

          style: TextStyle(
            decoration: isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,

            color: isCompleted ? Colors.grey : Colors.black,

            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Row(
          children: [
            Chip(
              label: Text("$weight kg"),
              backgroundColor: isCompleted ? Colors.grey[300] : Colors.white,
            ),

            const SizedBox(width: 6),

            Chip(
              label: Text("$reps reps"),
              backgroundColor: isCompleted ? Colors.grey[300] : Colors.white,
            ),

            const SizedBox(width: 6),

            Chip(
              label: Text("$sets sets"),
              backgroundColor: isCompleted ? Colors.grey[300] : Colors.white,
            ),
          ],
        ),

        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
      ),
    );
  }
}
