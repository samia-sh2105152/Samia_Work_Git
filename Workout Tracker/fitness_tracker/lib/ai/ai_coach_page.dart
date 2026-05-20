import 'package:fitness_tracker/services/ai_service.dart';
import 'package:flutter/material.dart';

class AiCoachPage extends StatefulWidget {
  const AiCoachPage({super.key});

  @override
  State<AiCoachPage> createState() => _AiCoachPageState();
}

class _AiCoachPageState extends State<AiCoachPage> {
  final goalController = TextEditingController();
  final daysController = TextEditingController();

  String selectedLevel = "Beginner";
  String aiResponse = "";
  bool isLoading = false;
  Future<void> generatePlan() async {
    setState(() {
      isLoading = true;
      aiResponse = "";
    });

    try {
      final result = await AIService.generateWorkoutPlan(
        goal: goalController.text,
        level: selectedLevel,
        days: daysController.text,
      );

      setState(() {
        aiResponse = result;
      });
    } catch (e) {
      setState(() {
        aiResponse = "Something went wrong: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    goalController.dispose();
    daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Fitness Coach")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Create a personalized workout plan",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: goalController,
            decoration: const InputDecoration(
              labelText: "Fitness goal",
              hintText: "e.g. build muscle, lose fat, improve stamina",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: selectedLevel,
            decoration: const InputDecoration(
              labelText: "Fitness level",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "Beginner", child: Text("Beginner")),
              DropdownMenuItem(
                value: "Intermediate",
                child: Text("Intermediate"),
              ),
              DropdownMenuItem(value: "Advanced", child: Text("Advanced")),
            ],
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
              });
            },
          ),

          const SizedBox(height: 16),

          TextField(
            controller: daysController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Days per week",
              hintText: "e.g. 3",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: isLoading ? null : generatePlan,
            icon: const Icon(Icons.auto_awesome),
            label: Text(isLoading ? "Generating..." : "Generate Plan"),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),

          const SizedBox(height: 24),

          if (aiResponse.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(aiResponse, style: const TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
}
