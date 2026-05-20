import 'package:fitness_tracker/components/exercise_tile.dart';
import 'package:fitness_tracker/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).checkOffExercise(workoutName, exerciseName);
  }

  //text controller
  final exerciseNameControler = TextEditingController();
  final exerciseWeightControler = TextEditingController();
  final exerciseRepsControler = TextEditingController();
  final exerciseSetsControler = TextEditingController();

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add new exercise"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //name
            TextField(
              controller: exerciseNameControler,
              decoration: InputDecoration(
                labelText: "Exercise Name:",
                hintText: "e.g. Biceps Curl",
              ),
            ),

            //weight
            TextField(
              controller: exerciseWeightControler,
              decoration: InputDecoration(
                labelText: "Weight:",
                hintText: "e.g. 10",
                suffixText: "kg",
              ),
            ),

            //reps
            TextField(
              controller: exerciseRepsControler,
              decoration: InputDecoration(
                labelText: "Reps:",
                hintText: "e.g. 12",
                suffixText: "reps",
              ),
            ),
            //sets
            TextField(
              controller: exerciseSetsControler,
              decoration: InputDecoration(
                labelText: "Sets:",
                hintText: "e.g. 3",
                suffixText: "sets",
              ),
            ),
          ],
        ),
        actions: [
          //save button
          MaterialButton(onPressed: save, child: Text("Save")),
          //cancel button
          MaterialButton(onPressed: cancel, child: Text("Cancel")),
        ],
      ),
    );
  }

  void save() {
    String exerciseName = exerciseNameControler.text;
    String weight = exerciseWeightControler.text;
    String reps = exerciseRepsControler.text;
    String sets = exerciseSetsControler.text;
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).addExercise(widget.workoutName, exerciseName, weight, reps, sets);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameControler.clear();
    exerciseWeightControler.clear();
    exerciseRepsControler.clear();
    exerciseSetsControler.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExerciseInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .name,
            weight: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .weight,
            reps: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .sets,
            isCompleted: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
              widget.workoutName,
              value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .name,
            ),
          ),
        ),
      ),
    );
  }
}
