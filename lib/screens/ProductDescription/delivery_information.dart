import 'package:flutter/material.dart';
import '../../size_config.dart';

class DeliveryInformation extends StatelessWidget {
  String? edd;
  DeliveryInformation({required this.edd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery',
          style: TextStyle(
              fontFamily: 'RecklessNeue',
              fontSize: 2*SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 2*SizeConfig.heightMultiplier,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 6*SizeConfig.widthMultiplier,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/image/splashlogo.png'),
                ),
                SizedBox(width: 1.5*SizeConfig.widthMultiplier,),
                Column(
                  children: [
                    Text(
                      'COD',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 1.9*SizeConfig.textMultiplier,
                          color: Color(0xff777777)
                      ),
                    ),
                    SizedBox(height: 0.5*SizeConfig.heightMultiplier,),
                    Text(
                      'Available',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 1.9*SizeConfig.textMultiplier,
                          color: Color(0xff777777)
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 6*SizeConfig.widthMultiplier,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/image/splashlogo.png'),
                ),
                SizedBox(width: 1.5*SizeConfig.widthMultiplier,),
                Column(
                  children: [
                    Text(
                      '30 days',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 1.9*SizeConfig.textMultiplier,
                          color: Color(0xff777777)
                      ),
                    ),
                    SizedBox(height: 0.5*SizeConfig.heightMultiplier,),
                    Text(
                      'return & exchange',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 1.9*SizeConfig.textMultiplier,
                          color: Color(0xff777777)
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 6*SizeConfig.widthMultiplier,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/image/splashlogo.png'),
                ),
                SizedBox(width: 1.5*SizeConfig.widthMultiplier,),
                Column(
                  children: [
                    Text(
                      'Estimated Delivery within',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 1.9*SizeConfig.textMultiplier,
                          color: Color(0xff777777)
                      ),
                    ),
                    SizedBox(height: 0.5*SizeConfig.heightMultiplier,),
                    Text(
                      '${edd}',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 1.9*SizeConfig.textMultiplier,
                          color: Color(0xff777777)
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
