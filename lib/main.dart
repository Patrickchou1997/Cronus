import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cronus Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.bold) // Set the back button color to white
            ),
      ),
      home: const MyHomePage(title: 'Cronus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Exercise> exercises = [
  Exercise(
      id: "E0",
      title: "Push-ups",
      reps: 15,
      duration: const Duration(seconds: 15)),
  Exercise(
      id: "E1",
      title: "Squats",
      reps: 20,
      duration: const Duration(seconds: 20)),
];

class _MyHomePageState extends State<MyHomePage> {
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

class Exercise {
  final String title;
  final int reps;
  final Duration duration;
  final String id;

  Exercise(
      {required this.id,
      required this.title,
      required this.reps,
      required this.duration});
}

class TimerScreen extends StatefulWidget {
  final Exercise exercise;

  const TimerScreen({super.key, required this.exercise});

  @override
  // ignore: library_private_types_in_public_api
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.exercise.duration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        // Timer is complete, you can show a completion dialog or navigate back
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.exercise.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Implement the action when the settings icon is pressed
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          '$_remainingSeconds',
          style: const TextStyle(fontSize: 86),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
