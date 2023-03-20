import 'package:flutter/material.dart';
import 'package:ouat/size_config.dart';
import 'package:shimmer/shimmer.dart';

class PdpShimmer extends StatelessWidget {
  //const PdpShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight/1.2,
            color: Color(0xFFDBFFE9),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
          ),
          Container(
            width: 140.0,
            height: 8.0,
            color: Color(0xFFDBFFE9),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          Container(
            width: 140.0,
            height: 8.0,
            color: Color(0xFFDBFFE9),
          ),
        ],
      ),
    );
  }
}
