import 'package:fitness_tracker/ai/ai_coach_page.dart';
import 'package:fitness_tracker/components/heat_map.dart';
import 'package:fitness_tracker/components/workout_card.dart';
import 'package:fitness_tracker/data/theme_provider.dart';
import 'package:fitness_tracker/data/workout_data.dart';
import 'package:fitness_tracker/pages/dashboard_page.dart';
import 'package:fitness_tracker/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();
  String searchQuery = "";

  void createWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Workout"),
        content: TextField(controller: newWorkoutNameController),
        actions: [
          //save button
          MaterialButton(onPressed: save, child: Text("Save")),
          //cancel button
          MaterialButton(onPressed: cancel, child: Text("Cancel")),
        ],
      ),
    );
  }

  void updateWorkoutDialog(String oldName) {
    newWorkoutNameController.text = oldName;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Workout"),
        content: TextField(controller: newWorkoutNameController),
        actions: [
          MaterialButton(
            onPressed: () {
              String newName = newWorkoutNameController.text;

              Provider.of<WorkoutData>(
                context,
                listen: false,
              ).updateWorkoutName(oldName, newName);

              Navigator.pop(context);
              clear();
            },
            child: Text("Update"),
          ),
          MaterialButton(onPressed: cancel, child: Text("Cancel")),
        ],
      ),
    );
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  //go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  String getGreeting() {
    int hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning 👋";
    } else if (hour < 17) {
      return "Good Afternoon 👋";
    } else {
      return "Good Evening 👋";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) {
        final filteredWorkouts = value.getWorkoutList().where((workout) {
          return workout.name.toLowerCase().contains(searchQuery);
        }).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text("Fitness Tracker"),
            actions: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AiCoachPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.analytics),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createWorkout,
            child: const Icon(Icons.add),
          ),

          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                getGreeting(),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "${value.getTotalWorkouts()} Workouts Created",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),

              const SizedBox(height: 16),

              LinearProgressIndicator(
                value: value.getCompletionPercentage(),
                minHeight: 10,
                borderRadius: BorderRadius.circular(20),
              ),

              const SizedBox(height: 8),

              Text(
                "${(value.getCompletionPercentage() * 100).toStringAsFixed(0)}% Overall Progress",
                style: TextStyle(color: Colors.grey[700]),
              ),

              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search workouts...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              Text(
                "My Workouts",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = filteredWorkouts[index];

                  return Dismissible(
                    key: Key(workout.name),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete Workout"),
                          content: Text(
                            "Are you sure you want to delete ${workout.name}?",
                          ),
                          actions: [
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },

                    onDismissed: (direction) {
                      Provider.of<WorkoutData>(
                        context,
                        listen: false,
                      ).deleteWorkout(workout.name);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${workout.name} deleted")),
                      );
                    },
                    child: WorkoutCard(
                      workoutName: workout.name,
                      exerciseCount: workout.exercises.length,
                      onEdit: () => updateWorkoutDialog(workout.name),
                      onTap: () => goToWorkoutPage(workout.name),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
