import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamal_v1/model/workout.dart';
import 'package:jamal_v1/model/exercise.dart' as ex;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:jamal_v1/ui/suggested_workouts.dart';
import 'package:jamal_v1/model/equipment.dart';
import 'package:jamal_v1/model/fitness.dart';
import 'package:jamal_v1/widgets/navigation_menu.dart';

class Suggester extends StatefulWidget {
  FitnessLevel userFitness;

  Suggester({Key key, this.userFitness}) : super(key: key);
  @override
  _SuggesterState createState() => _SuggesterState();
}

class _SuggesterState extends State<Suggester> {
  //user's available time
  final _multiformkey = GlobalKey<FormFieldState>();
  List<MultiSelectItem> equipment = Equipment.values
      .map((e) => MultiSelectItem<Equipment>(e, getEquipment(e)))
      .toList();

  List<Equipment> selectedEquipment = [];

  String uid = FirebaseAuth.instance.currentUser.uid;
  List<ex.Exercise> chestExercises = [];
  List<ex.Exercise> backExercises = [];
  List<ex.Exercise> legExercises = [];
  List<ex.Exercise> abExercises = [];
  List<ex.Exercise> tricepExercises = [];
  List<ex.Exercise> bicepExercises = [];
  List<ex.Exercise> shoulderExercises = [];
  List<ex.Exercise> cardioExercises = [];

  //all exercises in list form;
  void initState() {
    chestExercises = getSuitableExercises(ex.Focus.Chest);
    backExercises = getSuitableExercises(ex.Focus.Back);
    legExercises = getSuitableExercises(ex.Focus.Legs);
    abExercises = getSuitableExercises(ex.Focus.Abs);
    tricepExercises = getSuitableExercises(ex.Focus.Tricep);
    bicepExercises = getSuitableExercises(ex.Focus.Bicep);
    shoulderExercises = getSuitableExercises(ex.Focus.Shoulder);
    cardioExercises = getSuitableExercises(ex.Focus.Cardio);

    super.initState();
  }

  int daysInWeek = 7;
  int weeksInMonth = 4;

  @override
  Widget build(BuildContext context) {
    // final userFitness =
    //     ModalRoute.of(context).settings.arguments as FitnessLevel;
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Workout Suggester'),
          centerTitle: true,
          //backgroundColor: Colors.black87,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                child: Image.asset("assets/bg.jpg"),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // decoration: BoxDecoration(
                //   color: Colors.blueAccent,
                // ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Select Available Equipment ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      margin: EdgeInsets.all(20),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: MultiSelectChipField<Equipment>(
                        items: equipment,
                        key: _multiformkey,
                        title: Text('Select Available Equipment'),
                        headerColor: Colors.transparent,
                        decoration: BoxDecoration(color: Colors.transparent),
                        textStyle: TextStyle(
                          color: Colors.black,
                        ),
                        chipColor: Colors.white,
                        validator: (values) {
                          return values.length < 1 ? 'Select at least one' : '';
                        },
                        showHeader: false,
                        onTap: (values) {
                          selectedEquipment = values;
                          print(Scrollable.of(context).position.pixels);

                          _multiformkey.currentState.validate();
                        },
                        scrollControl: (controller) {
                          scrollAnimation(controller);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent),
                      child: Text('Get Suggestions!'),
                      onPressed: () {
                        print('Confirmed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuggestedWorkout(),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        child: Text('nice'),
                        onPressed: () {
                          print(widget.userFitness.index);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  List<ex.Exercise> getSuitableExercises(ex.Focus focus) {
    int difficultyLevel = widget.userFitness.index;
    return Workout.allExercises
        .where((exercise) =>
            exercise.focus.contains(focus) &&
            exercise.difficulty.index <= difficultyLevel)
        .toList();
  }

  List<Workout> getBeginnerExercises() {
//   Beginner:
// 2 Workouts per week:
// 1) Chest, Back, Legs, Abs
// 2) Shoulder, Bicep, Triceps, Legs, Abs
// Sets = weeksInMonth
// 10 <= Reps <= 20
// 10 <= Time <= 30
    int sets = 4;
    int minReps = 10;
    int minTime = 10;
    int repsIncrease = 2;
    int timeIncrease = 5;

    Random rnd = Random();

    List<ex.Exercise> weeklyExercise1 = [
      chestExercises[rnd.nextInt(chestExercises.length)],
      backExercises[rnd.nextInt(chestExercises.length)],
      legExercises[rnd.nextInt(legExercises.length)],
      abExercises[rnd.nextInt(abExercises.length)],
    ];
    List<ex.Exercise> weeklyExercise2 = [
      shoulderExercises[rnd.nextInt(shoulderExercises.length)],
      bicepExercises[rnd.nextInt(bicepExercises.length)],
      tricepExercises[rnd.nextInt(bicepExercises.length)],
      legExercises[rnd.nextInt(legExercises.length)],
      abExercises[rnd.nextInt(abExercises.length)],
    ];
    weeklyExercise1.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });
    weeklyExercise2.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });
    Workout weeklyWorkout1 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise1);
    Workout weeklyWorkout2 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise2);

    List<Workout> weeklyWorkoutList = [weeklyWorkout1, weeklyWorkout2];
    List<Workout> monthlyWorkouts = [];

    for (int i = 0; i < weeksInMonth; i++) {
      //restdaysInWeek
      int interWeekMultiplier = 7 * i;
      for (Workout workout in weeklyWorkoutList) {
        int intraWeekMultiplier =
            (daysInWeek / weeklyWorkoutList.length).floor() *
                weeklyWorkoutList.indexOf(workout);

        Workout tempWorkout = workout.setDate(DateTime.now()
            .add(Duration(days: intraWeekMultiplier + interWeekMultiplier)));

        monthlyWorkouts.add(tempWorkout);
      }
    }

    return monthlyWorkouts;
  }

  List<Workout> getIntermediateExercises() {
//     Intermediate:
// 3 Workouts per week:
// 1) Chest, Back, Legs, Abs
// 2) Shoulder, Bicep, Triceps, Legs, Abs
// 3) 3 x Cardio Exercises

// Sets = weeksInMonth
// 10 <= Reps <= 20
// 10 <= Time <= 30

    int sets = weeksInMonth;
    int minReps = 10;
    int minTime = 10;
    int repsIncrease = 2;
    int timeIncrease = 5;

    Random rnd = Random();

    List<ex.Exercise> weeklyExercise1 = [
      chestExercises[rnd.nextInt(chestExercises.length)],
      backExercises[rnd.nextInt(chestExercises.length)],
      legExercises[rnd.nextInt(legExercises.length)],
      abExercises[rnd.nextInt(abExercises.length)],
    ];
    List<ex.Exercise> weeklyExercise2 = [
      shoulderExercises[rnd.nextInt(shoulderExercises.length)],
      bicepExercises[rnd.nextInt(bicepExercises.length)],
      tricepExercises[rnd.nextInt(bicepExercises.length)],
      legExercises[rnd.nextInt(legExercises.length)],
      abExercises[rnd.nextInt(abExercises.length)],
    ];

    List<int> tempList = getRandomIntList(cardioExercises.length);
    List<ex.Exercise> weeklyExercise3 = [
      cardioExercises[tempList[0]],
      cardioExercises[tempList[1]],
      cardioExercises[tempList[2]],
    ];

    Workout weeklyWorkout1 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise1);
    Workout weeklyWorkout2 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise2);
    Workout weeklyWorkout3 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise3);

    weeklyExercise1.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });

    weeklyExercise2.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });

    weeklyExercise3.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });

    List<Workout> weeklyWorkoutList = [
      weeklyWorkout1,
      weeklyWorkout2,
      weeklyWorkout3
    ];

    List<Workout> monthlyWorkouts = [];

    for (int i = 0; i < weeksInMonth; i++) {
      //restdaysInWeek
      int interWeekMultiplier = 7 * i;
      for (Workout workout in weeklyWorkoutList) {
        int intraWeekMultiplier =
            (daysInWeek / weeklyWorkoutList.length).floor() *
                weeklyWorkoutList.indexOf(workout);

        Workout tempWorkout = workout.setDate(DateTime.now()
            .add(Duration(days: intraWeekMultiplier + interWeekMultiplier)));

        monthlyWorkouts.add(tempWorkout);
      }
    }

    return monthlyWorkouts;
  }

  List<Workout> getAdvancedExercises() {
//     Intermediate:
// 3 Workouts per week:
// 1) Chest, Back, Legs, Abs
// 2) Shoulder, Bicep, Triceps, Legs, Abs
// 3) 3 x Cardio Exercises

// Sets = weeksInMonth
// 10 <= Reps <= 20
// 10 <= Time <= 30

    int sets = weeksInMonth;
    int minReps = 10;
    int minTime = 10;
    int repsIncrease = 2;
    int timeIncrease = 5;

    Random rnd = Random();

    List<ex.Exercise> weeklyExercise1 = [
      chestExercises[rnd.nextInt(chestExercises.length)],
      backExercises[rnd.nextInt(chestExercises.length)],
      legExercises[rnd.nextInt(legExercises.length)],
      abExercises[rnd.nextInt(abExercises.length)],
    ];
    List<ex.Exercise> weeklyExercise2 = [
      shoulderExercises[rnd.nextInt(shoulderExercises.length)],
      bicepExercises[rnd.nextInt(bicepExercises.length)],
      tricepExercises[rnd.nextInt(bicepExercises.length)],
      legExercises[rnd.nextInt(legExercises.length)],
      abExercises[rnd.nextInt(abExercises.length)],
    ];

    List<int> tempList = getRandomIntList(cardioExercises.length);
    List<ex.Exercise> weeklyExercise3 = [
      cardioExercises[tempList[0]],
      cardioExercises[tempList[1]],
      cardioExercises[tempList[2]],
    ];

    List<ex.Exercise> weeklyExercise4 = [
      chestExercises[rnd.nextInt(chestExercises.length)],
      backExercises[rnd.nextInt(chestExercises.length)],
      legExercises[rnd.nextInt(legExercises.length)],
      abExercises[rnd.nextInt(abExercises.length)],
    ];

    Workout weeklyWorkout1 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise1);
    Workout weeklyWorkout2 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise2);
    Workout weeklyWorkout3 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise3);
    Workout weeklyWorkout4 =
        Workout(rest: Duration(minutes: 1), exercises: weeklyExercise4);

    weeklyExercise1.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });

    weeklyExercise2.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });

    weeklyExercise3.map((exercise) {
      exercise.sets = sets;
      if (exercise.isTimed) {
        exercise.time = Duration(seconds: minTime);
      } else {
        exercise.reps = minReps;
      }
    });

    List<Workout> weeklyWorkoutList = [
      weeklyWorkout1,
      weeklyWorkout2,
      weeklyWorkout3,
      weeklyWorkout4,
    ];

    List<Workout> monthlyWorkouts = [];

    for (int i = 0; i < weeksInMonth; i++) {
      //restdaysInWeek
      int interWeekMultiplier = 7 * i;
      for (Workout workout in weeklyWorkoutList) {
        int intraWeekMultiplier =
            (daysInWeek / weeklyWorkoutList.length).floor() *
                weeklyWorkoutList.indexOf(workout);

        Workout tempWorkout = workout.setDate(DateTime.now()
            .add(Duration(days: intraWeekMultiplier + interWeekMultiplier)));

        monthlyWorkouts.add(tempWorkout);
      }
    }

    return monthlyWorkouts;
  }
}

List<int> getRandomIntList(int x) {
  Random rnd = Random();
  Set<int> tempSet = Set();
  while (tempSet.length < x) {
    tempSet.add(rnd.nextInt(x));
  }
  return tempSet.toList();
}

void scrollAnimation(ScrollController controller) {
  // when using more than one animation, use async/await
  Future.delayed(const Duration(milliseconds: 500), () async {
    await controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 5000), curve: Curves.linear);

    await controller.animateTo(controller.position.minScrollExtent,
        duration: Duration(milliseconds: 1250),
        curve: Curves.fastLinearToSlowEaseIn);
  });
}
