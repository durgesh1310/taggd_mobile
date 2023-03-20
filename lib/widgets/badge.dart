import 'package:flutter/material.dart';

class Badge extends StatelessWidget {

   Badge(
       this.child,
    this.value,
       this.color,
       this.right,
       this.top
  );

  Widget child;
  String value;
  Color color;
  double right;
  double top;

  @override
  Widget build(BuildContext context) {
    return value != "" ?
    Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: right,
          top: top,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white
              ),
            ),
          ),
        )
      ],
    ):
    child;
  }
}
