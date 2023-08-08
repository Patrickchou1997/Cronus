import 'package:cronus_project/containers/timer_screen/time_screen.dart';
import 'package:cronus_project/models/exercise.model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<Exercise> exercises = [
  Exercise(
      id: "E0",
      title: "Push-ups",
      type: "F",
      reps: 15,
      duration: const Duration(seconds: 15)),
  Exercise(
      id: "E1",
      title: "Squats",
      type: "T",
      reps: 20,
      duration: const Duration(seconds: 20)),
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(exercise.id), // Unique key for each exercise
            onDismissed: (direction) {
              setState(() {
                exercises.removeAt(index); // Remove the exercise from the list
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${exercise.title} dismissed'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
            child: ListTile(
              leading: (exercise.type != "F")
                  ? const Icon(Icons.timer_outlined)
                  : const Icon(Icons.folder_outlined),
              title: Text(exercise.title),
              subtitle: Text('Reps: ${exercise.reps}'),
              onTap: () {
                // Navigate to a timer screen with the selected exercise
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TimerScreen(exercise: exercise)),
                );
              },
              trailing: IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.edit_outlined)),
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExerciseDialog(context);
        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<void> _showAddExerciseDialog(BuildContext context) async {
    String title = '';
    int reps = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Exercise Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Number of Reps'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  reps = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  exercises.add(Exercise(
                      id: "E${exercises.length}",
                      title: title,
                      type: "T",
                      reps: reps,
                      duration: Duration(seconds: reps)));
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
