import 'dart:io';
import 'package:flutter/material.dart';

class AppUpdatedScreen extends StatefulWidget {
  late Function? onCallback;
  String? versionName;
  String? whatsNew;

  AppUpdatedScreen({this.onCallback, this.versionName, this.whatsNew});

  @override
  _AppUpdatedScreenState createState() => _AppUpdatedScreenState();
}

class _AppUpdatedScreenState extends State<AppUpdatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 50, left: 25),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 35,
                ),
                onPressed: () async {
                  //Cancel by user

                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 174,
                  width: 174,
                  alignment: Alignment.center,
                  child: Container(
                    height: 46,
                    width: 123,
                    child: Image.asset("assets/image/splashlogo.png"),
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                Text(
                  "Updated Version\nAvailable",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Fraunces',
                      fontWeight: FontWeight.w800,
                      fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "${widget.whatsNew}",
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFA5A5A5),
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      Platform.isIOS
                          ? "Version ${widget.versionName} is available in the App Store."
                          : "Version ${widget.versionName} is available in the Play Store.",
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFA5A5A5),
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.08,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.white),
                  child: Text(
                    "Update Now",
                    style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFA5A5A5),
                        fontSize: 18),
                  ),
                ),
                onTap: () {
                  widget.onCallback!();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
