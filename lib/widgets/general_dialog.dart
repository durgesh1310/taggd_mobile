import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import '../size_config.dart';

class GeneralDialog extends StatefulWidget {
  static Future show(BuildContext context,
      {GlobalKey? key,
      String? title,
      Widget? titleWidget,
      String? message,
      Widget? child,
      String? positiveButtonLabel,
      Function? onPositiveTap,
      String? negativeButtonLabel,
      Function? onNegativeTap,
      bool closeOnAction = true}) async {
    return showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: GeneralDialog(
          key: key,
          title: title,
          titleWidget: titleWidget,
          message: message,
          child: child,
          positiveButtonLabel: positiveButtonLabel,
          onPositiveTap: onPositiveTap,
          negativeButtonLabel: negativeButtonLabel,
          onNegativeTap: onNegativeTap,
          closeOnAction: closeOnAction,
        ),
      ),
    );
  }

  final String? title;
  final Widget? titleWidget;
  final String? message;
  final Widget? child;
  final Function? onPositiveTap;
  final String? positiveButtonLabel;
  final String? negativeButtonLabel;
  final Function? onNegativeTap;
  final bool? closeOnAction;

  GeneralDialog(
      {GlobalKey? key,
      this.title,
      this.titleWidget,
      this.message,
      this.child,
      this.positiveButtonLabel,
      this.onPositiveTap,
      this.negativeButtonLabel,
      this.onNegativeTap,
      this.closeOnAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GeneralDialogState(
        title: this.title,
        titleWidget: this.titleWidget,
        message: this.message,
        child: this.child,
        positiveButtonLabel: this.positiveButtonLabel,
        onPositiveTap: this.onPositiveTap,
        negativeButtonLabel: this.negativeButtonLabel,
        onNegativeTap: this.onNegativeTap,
        closeOnAction: this.closeOnAction);
  }
}

class _GeneralDialogState extends State {
  final String? title;
  final Widget? titleWidget;
  final String? message;
  final Widget? child;
  final Function? onPositiveTap;
  final String? positiveButtonLabel;
  final String? negativeButtonLabel;
  final Function? onNegativeTap;
  final bool? closeOnAction;

  late ThemeData _themeData;
  _GeneralDialogState(
      {this.title,
      this.titleWidget,
      this.message,
      this.child,
      this.positiveButtonLabel,
      this.onPositiveTap,
      this.negativeButtonLabel,
      this.onNegativeTap,
      this.closeOnAction})
      : assert(title != null || titleWidget != null);

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    double textScale = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
        return true;
      },
      child: Scaffold(
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
                    height: SizeConfig.screenHeight/2.9,
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
                                    text: 'So Sorry! We are doing our best \n',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0xff5F5F5F),
                                      fontSize: 15
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'and we\'ll be back soon.',
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius:  BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1 * SizeConfig.widthMultiplier)),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                          },
                          child: Container(
                            width: 22* SizeConfig.widthMultiplier,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SvgPicture.asset(
                                  'assets/image/icon-back-arrow.svg',
                                ),
                                Text(
                                    'Go Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: textScale>0 ? 1.5*SizeConfig.textMultiplier : SizeConfig.textMultiplier
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
