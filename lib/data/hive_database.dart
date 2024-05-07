import 'package:hive/hive.dart';
import 'package:workout_app/Model/workout.dart';
import 'package:workout_app/Model/exercies.dart';
import 'package:workout_app/datetime/date_time.dart';

class Hivedatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database");

  // check if there is already data stored , it not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      // print('previous data dose Not exist ');
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      // print('previous data dose exist ');
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write data
  void saveToDataBase(List<Workout> workouts) {
    //convert the workout object into a list of  string to store it in hive
    final workoutList = convertObjectToWorkoutlist(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*
            check if any exerc
            
            return 0; ise has been done 
            we will put a 0 or a 1 for each yyyymmdd date 
             */

    if (exerciseIsComplited(workouts)) {
      _myBox.put("COMPLETION_STATUS${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS${todaysDateYYYYMMDD()}", 0);
    }
    // "COMPLETION_STATUS_20240504" it could be 0 or 1
    //
    //save it into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXCERCISES", exerciseList);
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<dynamic> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXCERCISES");

    // create a workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exerciesInEachWorkout = [];

      for (int j = 0; j < exerciseDetails.length; j++) {
        // so add each exercise into a list
        exerciesInEachWorkout.add(Exercise(
          name: exerciseDetails[i][j][0],
          weight: exerciseDetails[i][j][1],
          reps: exerciseDetails[i][j][2],
          sets: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
        ));
      }

      // create individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercise: exerciesInEachWorkout);

      // add individual workout to the over all list
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

// check if any ecercise have been done
  bool exerciseIsComplited(List<Workout> workouts) {
    // go thru each workout
    for (var workout in workouts) {
      for (var exercise in workout.exercise) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

// return  completion status of a given date yyyyddmm
  int getCompletionStatus(String yyyymmdd) {
    //returns  0 or 1, if null  then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

//convert workout objects into a list --> eg. [upperbody , lowerbody] just the name
List<String> convertObjectToWorkoutlist(List<Workout> workouts) {
  List<String> workoutList = [
    // eg. [upperbody , lowerbody]
  ];

  for (int i = 0; i < workouts.length; i++) {
    // in each workout , add the name, followed by lists of exercises
    workoutList.add(workouts[i].name);
  }

  return workoutList;
}

// coverts the exercises in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    /*
    [

      Upper body
      [  [ biseps, 10kg , 10reps , 3sets], [tricpes, 20kg, 10reps, 3sets]  ]



      lower body 
      [  [squats , 25kg, 9reps, 3sets] , [legeraise, 30kg , 9reps , 3 sets ] , [calf , 20kg, 9reps, 3sets ] ]
    ]
     */
  ];

  // go through each workout
  for (int i = 0; i < workouts.length; i++) {
    // get exercises from each workout
    List<Exercise> exerciesInWorkout = workouts[i].exercise;

    List<List<String>> individualWorkout = [
      // Upper body
      //  [  [ biseps, 10kg , 10reps , 3sets], [tricpes, 20kg, 10reps, 3sets]  ]
    ];

    // go through  each exercise in exercise list
    for (int j = 0; j < exerciesInWorkout.length; j++) {
      List<String> individualExercise = [
        // [biceps , 20kg, 8reps, 3sets]
      ];

      individualExercise.addAll([
        exerciesInWorkout[j].name,
        exerciesInWorkout[j].weight,
        exerciesInWorkout[j].reps,
        exerciesInWorkout[j].sets,
        exerciesInWorkout[j].isCompleted.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }
    // exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
