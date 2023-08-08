class Exercise {
  final String title;
  final String type;
  final int reps;
  final Duration duration;
  final String id;

  Exercise(
      {required this.id,
      required this.title,
      required this.type,
      required this.reps,
      required this.duration});
}
