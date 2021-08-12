import 'package:flutter/material.dart';
import 'package:jamal_v1/model/exercise.dart' as ex;
import 'package:jamal_v1/model/fitness.dart';
import 'package:jamal_v1/ui/demonstration.dart';
import 'package:jamal_v1/util/enum_methods.dart';

class AddExerciseCard extends StatefulWidget {
  final ex.Exercise exercise;
  final VoidCallback callback;
  const AddExerciseCard({Key key, this.exercise, this.callback})
      : super(key: key);

  @override
  _AddExerciseCardState createState() => _AddExerciseCardState();
}

class _AddExerciseCardState extends State<AddExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ex.getColour(widget.exercise.focus[0]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.callback,
          child: Container(
            padding: EdgeInsets.all(16),
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: buildText(),
                  flex: 3,
                ),
                Expanded(
                    child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: NetworkImage(widget.exercise.picURL))),
                  //child: Image.network(widget.exercise.picURL)
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    //widget is referring to the AddExerciseCard class
    //since i placed the exercise property there
    String name = widget.exercise.name;
    String focuses =
        widget.exercise.focus.map((e) => Enums.enumToString(e)).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Focus: ' + focuses,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
