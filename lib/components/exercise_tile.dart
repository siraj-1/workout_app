import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckBoxChanged;

  const ExerciseTile({
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
    return ListTile(
      title: Text('$exerciseName :'),
      subtitle: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            //weight
            Chip(
              label: Text(' Wieght: $weight',
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(
              width: 5,
            ),
            // reps
            Chip(
              label: Text(' Reps: $reps',
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(
              width: 5,
            ),
            // sets
            Chip(
              label: Text('Sets: $sets',
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey,
            ),
            Checkbox(
              value: isCompleted,
              onChanged: (value) => onCheckBoxChanged!(value),
            ),
          ],
        ),
      ),
    );
  }
}
