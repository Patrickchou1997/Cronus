import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cronus_project/models/exercise.model.dart';

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
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.exercise.duration.inSeconds;
    // _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlaying && _remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        if (isPlaying) {
          Navigator.pop(context);
        }
      }
    });
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      _startTimer();
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
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Implement the action when the settings icon is pressed
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              '$_remainingSeconds',
              style: const TextStyle(fontSize: 86),
            ),
          ),
          IconButton(
            icon: isPlaying
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
            onPressed: togglePlayPause,
            iconSize: 42.0,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
