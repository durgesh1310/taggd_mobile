import 'package:flutter/material.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import '../../size_config.dart';

class Offers extends StatelessWidget {
  List<String>? discountOffers;
  Offers(this.discountOffers);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Offers',
          style: TextStyle(
              fontFamily: 'RecklessNeue',
              fontSize: 2 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        Card(
          child: Column(
            children: discountOffers!.map((e) =>
                ListTile(
                  title: Text(
                      '${e}',
                    style: TextStyle(
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),
                  ),
                )).toList(),
          ),
        ),
        SizedBox(
          height: 1.5 * SizeConfig.heightMultiplier,
        ),
        Divider(
          color: const Color(0xfff9d8d8),
          thickness: 1,
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier,
        ),
      ],
    );
  }
}
