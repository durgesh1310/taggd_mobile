import 'package:flutter/material.dart';
import '../size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';


class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({ Key? key }) : super(key: key);

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/image/error.jpeg',
                // fit: BoxFit.fitWidth,.
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset('assets/image/icon-curve-right.png')),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
                    color: Colors.white,
                  ),
                  height: SizeConfig.screenHeight/3,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/image/icon-hanger.svg',
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'UH OH\n',
                              style: TextStyle(
                                  fontFamily: 'RecklessNeue',
                                  color: Color(0xff4D4D4D),
                                  fontSize: 20
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Check Your Internet Connection \n',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0xff5F5F5F),
                                      fontSize: 15
                                  ),
                                ),
                                TextSpan(
                                  text: 'and retry.',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0xff5F5F5F),
                                      fontSize: 15
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}