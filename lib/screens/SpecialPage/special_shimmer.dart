import 'package:flutter/material.dart';
import 'package:ouat/size_config.dart';
import 'package:shimmer/shimmer.dart';

class SpecialShimmer extends StatelessWidget {
  //const PdpShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight/2.5,
                color: Color(0xFFDBFFE9),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(2),
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 0.55,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  color: Color(0xFFDBFFE9),
                ),
                Container(
                  color: Color(0xFFDBFFE9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
