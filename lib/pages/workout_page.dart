import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/exercise_tile.dart';
import 'package:workout_app/data/work_out_data.dart';

class Workoutpage extends StatefulWidget {
  final String workoutName;

  const Workoutpage({super.key, required this.workoutName});

  @override
  State<Workoutpage> createState() => _WorkoutpageState();
}

class _WorkoutpageState extends State<Workoutpage> {
  // check box was tapped
  void onCheckBoxChanged(String workoutName, String exerciesName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercies(workoutName, exerciesName);
  }

  //text controller
  final exerciseNameController = TextEditingController();

  // wieght controller
  final wieghtController = TextEditingController();
  // reps controller
  final repsController = TextEditingController();
  // sets controller
  final setsController = TextEditingController();

  //create a new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add a new exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //exercise name
                  TextField(
                    controller: exerciseNameController,
                    decoration:
                        const InputDecoration(hintText: 'Exercise Name '),
                  ),
                  //wieght
                  TextField(
                    controller: wieghtController,
                    decoration: const InputDecoration(hintText: ' Wieght '),
                  ),
                  // reps
                  TextField(
                    controller: setsController,
                    decoration: const InputDecoration(hintText: ' Reps'),
                  ),
                  //sets
                  TextField(
                    controller: repsController,
                    decoration: const InputDecoration(hintText: ' Sets'),
                  )
                ],
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: const Text('save'),
                ),

                // cancel button
                MaterialButton(
                  onPressed: cansel,
                  child: const Text('cancel'),
                )
              ],
            ));
  }

  //save workout
  void save() {
    // u dont need to do like this
    // //get exercise name for the text controller
    // String newExerciseName = exerciseNameController.text;
    // String wieght = wieghtController.text;
    // String sets = setsController.text;
    // String reps = repsController.text;

    // add exercise to the workout list
    Provider.of<WorkoutData>(context, listen: false).addExercies(
      widget.workoutName,
      exerciseNameController.text,
      wieghtController.text,
      setsController.text,
      repsController.text,
    );
    // to pop out after save
    Navigator.pop(context);
    // to clear the text filed
    clear();
  }

  //cansel
  void cansel() {
    //to pop out after cansel
    Navigator.pop(context);
    // to clear the text filed
    clear();
  }

  // clear controler
  void clear() {
    exerciseNameController.clear();
    setsController.clear();
    repsController.clear();
    wieghtController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.theNumberOfExerciseInWorkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
                exerciseName: value
                    .getRelaventWorkout(widget.workoutName)
                    .exercise[index]
                    .name,
                weight: value
                    .getRelaventWorkout(widget.workoutName)
                    .exercise[index]
                    .weight,
                reps: value
                    .getRelaventWorkout(widget.workoutName)
                    .exercise[index]
                    .reps,
                sets: value
                    .getRelaventWorkout(widget.workoutName)
                    .exercise[index]
                    .sets,
                isCompleted: value
                    .getRelaventWorkout(widget.workoutName)
                    .exercise[index]
                    .isCompleted,
                onCheckBoxChanged: (val) {
                  onCheckBoxChanged(
                    widget.workoutName,
                    value
                        .getRelaventWorkout(widget.workoutName)
                        .exercise[index]
                        .name,
                  );
                })),
      ),
    );
  }
}
