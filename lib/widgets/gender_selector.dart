import 'package:flutter/material.dart';
import 'package:ouat/data/models/gender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ouat/widgets/custom_radioButton.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GenderSelector extends StatefulWidget {
  GenderSelector();
  @override
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  List<Gender> genders = <Gender>[];
  late SharedPreferences userData;

  @override
  void initState() {
    super.initState();
    genders.add(Gender("MALE", MdiIcons.genderMale, false));
    genders.add(Gender("FEMALE", MdiIcons.genderFemale, false));
    genders.add(Gender("OTHERS", MdiIcons.genderTransgender, false));
    initSharedPref();
  }

  void initSharedPref() async{
    userData = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: genders.length,
        itemBuilder: (context, index) {
          return InkWell(
            splashColor: Colors.pinkAccent,
            onTap: () {
              setState(() {
                genders.forEach((gender) => gender.isSelected = false);
                genders[index].isSelected = true;
                userData.setString('gender', genders[index].name);
              });
            },
            child: CustomRadio(genders[index]),
          );
        });
  }
}