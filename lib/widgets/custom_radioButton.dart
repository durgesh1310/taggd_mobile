import 'package:flutter/material.dart';
import 'package:ouat/data/models/gender.dart';

class CustomRadio extends StatelessWidget {
  Gender _gender;

  CustomRadio(this._gender);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: _gender.isSelected ? Colors.black : Colors.white,
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          margin: new EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                _gender.icon,
                color: _gender.isSelected ? Colors.white : Colors.grey[600],
                size: 35,
              ),
              SizedBox(height: 10),
              Text(
                _gender.name,
                style: TextStyle(
                    color: _gender.isSelected ? Colors.white : Colors.grey[600]),
              )
            ],
          ),
        ));
  }
}