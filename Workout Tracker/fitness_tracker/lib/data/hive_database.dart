import 'package:fitness_tracker/datetime/date_time.dart';
import 'package:fitness_tracker/models/exercise.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  //reference hivebox
  final _myBox = Hive.box("workout_database");

  bool previousDataExits() {
    if (_myBox.isEmpty) {
      print("No Previous Data");
      _myBox.put("START_DATE_", todaysDateDDMMYYYY());
      return false;
    } else {
      print("Previous Data Found");
      return true;
    }
  }

  //startdate
  String getStartDate() {
    return _myBox.get("START_DATE_");
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObejctToExerciseList(workouts);

    //check if exercise done
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateDDMMYYYY()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateDDMMYYYY()}", 0);
    }

    //save in hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read data and return list of Workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySaveWorkouts = [];
    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true",
          ),
        );
      }

      //create individual workout
      Workout workout = Workout(
        name: workoutNames[i],
        exercises: exercisesInEachWorkout,
      );

      //add individual workout
      mySaveWorkouts.add(workout);
    }
    return mySaveWorkouts;
  }

  bool exerciseCompleted(List<Workout> workouts) {
    for (var w in workouts) {
      for (var e in w.exercises) {
        if (e.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus(String ddmmyyyy) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_$ddmmyyyy") ?? 0;

    return completionStatus;
  }
}

//convert workouts into list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }
  return workoutList;
}

//convert exercise into list
List<List<List<String>>> convertObejctToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];
  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exerciseIntoWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];
    for (int j = 0; j < exerciseIntoWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll([
        exerciseIntoWorkout[j].name,
        exerciseIntoWorkout[j].weight,
        exerciseIntoWorkout[j].reps,
        exerciseIntoWorkout[j].sets,
        exerciseIntoWorkout[j].isCompleted.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }

  return exerciseList;
}
