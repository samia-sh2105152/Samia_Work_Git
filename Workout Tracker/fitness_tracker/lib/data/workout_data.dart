import 'package:fitness_tracker/data/hive_database.dart';
import 'package:fitness_tracker/datetime/date_time.dart';
import 'package:fitness_tracker/models/exercise.dart';
import 'package:fitness_tracker/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutList = [
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(name: "Biceps Curl", weight: "10", reps: "10", sets: "3"),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(name: "Squats", weight: "10", reps: "10", sets: "3"),
      ],
    ),
  ];

  //if there are workouts in database
  void initializeWorkoutList() {
    if (db.previousDataExits()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }

    loadHeatMap();
  }

  //get workout
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //length of workout
  int numberOfExerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  //add workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  //add exercise
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    //find the workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  //deleteWorkout
  void deleteWorkout(String workoutName) {
    workoutList.removeWhere((workout) => workout.name == workoutName);
    db.saveToDatabase(workoutList);
    loadHeatMap();
    notifyListeners();
  }

  //deleteExercise
  void deleteExercise(String workoutName, String exerciseName) {
    Workout workout = getRelevantWorkout(workoutName);
    workout.exercises.removeWhere((exercise) => exercise.name == exerciseName);
    db.saveToDatabase(workoutList);
    loadHeatMap();
    notifyListeners();
  }

  //update Workout
  void updateWorkoutName(String oldName, String newName) {
    int workoutIndex = workoutList.indexWhere(
      (workout) => workout.name == oldName,
    );

    if (workoutIndex != -1) {
      workoutList[workoutIndex] = Workout(
        name: newName,
        exercises: workoutList[workoutIndex].exercises,
      );

      db.saveToDatabase(workoutList);
      notifyListeners();
    }
  }

  //update exercise
  void updateExercise(
    String workoutName,
    String oldExerciseName,
    String newExerciseName,
    String newWeight,
    String newReps,
    String newSets,
  ) {
    Workout workout = getRelevantWorkout(workoutName);

    int exerciseIndex = workout.exercises.indexWhere(
      (exercise) => exercise.name == oldExerciseName,
    );

    if (exerciseIndex != -1) {
      workout.exercises[exerciseIndex] = Exercise(
        name: newExerciseName,
        weight: newWeight,
        reps: newReps,
        sets: newSets,
        isCompleted: workout.exercises[exerciseIndex].isCompleted,
      );

      db.saveToDatabase(workoutList);
      loadHeatMap();
      notifyListeners();
    }
  }

  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    db.saveToDatabase(workoutList);

    loadHeatMap();
    notifyListeners();
  }

  // relevant workout
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutList.firstWhere(
      (workout) => workout.name == workoutName,
    );
    return relevantWorkout;
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercise relevantExercise = relevantWorkout.exercises.firstWhere(
      (exercise) => exercise.name == exerciseName,
    );
    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSets = {};
  void loadHeatMap() {
    heatMapDataSets = {};

    DateTime startDate = createDateTimeObject(getStartDate());
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i <= daysInBetween; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));

      String ddmmyyyy = convertDateTimeToYYYYMMDD(currentDate);
      int completionStatus = db.getCompletionStatus(ddmmyyyy);

      heatMapDataSets[DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
          )] =
          completionStatus;
    }
  }

  int getTotalWorkouts() {
    return workoutList.length;
  }

  int getTotalExercises() {
    int total = 0;

    for (var workout in workoutList) {
      total += workout.exercises.length;
    }

    return total;
  }

  int getCompletedExercises() {
    int completed = 0;

    for (var workout in workoutList) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          completed++;
        }
      }
    }

    return completed;
  }

  double getCompletionPercentage() {
    if (getTotalExercises() == 0) {
      return 0;
    }

    return getCompletedExercises() / getTotalExercises();
  }
}
