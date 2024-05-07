import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:workout_app/Model/workout.dart';
import 'package:workout_app/Model/exercies.dart';
import 'package:workout_app/data/hive_database.dart';

class WorkoutData extends ChangeNotifier {
  final db = Hivedatabase();

/*
          WORKOUT DATA STRUCTURE

          -this overall list contains the different workouts
          -Each list contains a name  , and list  of exerci ses
 */

  List<Workout> workoutList = [
    Workout(name: "Upper body", exercise: [
      Exercise(name: "Bicep curls", weight: "20", reps: "20", sets: "3")
    ]),
    Workout(name: "Lower body", exercise: [
      Exercise(name: "squats", weight: "20", reps: "20", sets: "3")
    ])
  ];

  // if there is workouts already in database , then get that workout list , otherwise use default workout
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDataBase(workoutList);
    }
  }

  // get the list of workout's
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get the lenght of a given workout
  int theNumberOfExerciseInWorkout(String workoutName) {
    Workout relaventWorkout = getRelaventWorkout(workoutName);
    return relaventWorkout.exercise.length;
  }

  // add a workout
  void addWorkout(String name) {
    //add a new workout with a blank list of exercises
    workoutList.add(Workout(name: name, exercise: []));
    notifyListeners();

    // save to database
    db.saveToDataBase(workoutList);
  }

  // add an exercies to a workout
  void addExercies(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find the relevant workout
    Workout relaventWorkout = getRelaventWorkout(workoutName);

    relaventWorkout.exercise.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
    notifyListeners();

    // save to database
    db.saveToDataBase(workoutList);
  }

  //check off an exercies
  void checkOffExercies(String workoutName, String exerciesName) {
    // find the relavent workout and the relavent exercises
    Exercise relaventExercies = getRelaventExercies(workoutName, exerciesName);

    // check off boolean to show the user completed the exercise
    // relaventExercies.isCompleted == !relaventExercies.isCompleted;  <===  `this was somthing u fixed your own habibi`
    relaventExercies.isCompleted = !relaventExercies.isCompleted;
    log('tapped');
    notifyListeners();

    // save to database
    db.saveToDataBase(workoutList);
  }

  // return relavent workout object , given  a workout name
  Workout getRelaventWorkout(String workoutName) {
    Workout relaventWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relaventWorkout;
  }

  // get the relavent exercies
  Exercise getRelaventExercies(String workoutName, String exerciesName) {
    Workout relaventWorkout = getRelaventWorkout(workoutName);

    // get  the relavent exercies in that workout
    Exercise relaventExercies = relaventWorkout.exercise
        .firstWhere((exercise) => exercise.name == exerciesName);

    return relaventExercies;
  }
}
