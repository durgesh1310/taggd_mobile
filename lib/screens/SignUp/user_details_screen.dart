import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/widgets/gender_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../size_config.dart';

class UserDetails extends StatefulWidget {
  var callBackFunction;
  UserDetails(this.callBackFunction);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController name_controller = new TextEditingController();
  late SharedPreferences userData;

  @override
  void initState() {
    initSharedPref();
  }

  void initSharedPref() async {
    userData = await SharedPreferences.getInstance();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/image/name.jpg',
                fit: BoxFit.fitWidth,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: 24,
                        width: 24,
                        child: Image.asset('assets/image/icon-curve-right.png'))),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
                    color: Colors.white,
                  ),
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
                        child: Text(
                          'Latest collections of \n fashion, lifestyle, and more',
                          style: TextStyle(
                              fontSize: textScale > 1 ? 2.8*SizeConfig.textMultiplier : 3*SizeConfig.textMultiplier,
                              fontFamily: 'RecklessNeue',
                              fontWeight: FontWeight.w300,
                              color: Color(0xff4B4B4B)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.only(bottom: 30, left: 50, right: 50),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length < 2) {
                                return 'Your name must be at least 2 characters.';
                              }
                              return null;
                            },
                            controller: name_controller,
                            onTap: () {
                              //widget.callBackFunction(false);
                            },
                            cursorColor: Color(0xffcd3a62),
                            decoration: InputDecoration(
                              suffixIcon: Container(
                                height: 35,
                                width: 35,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.black, shape: BoxShape.circle),
                                child: IconButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      userData.setString(
                                          'name', name_controller.text.toString());
                                      widget.callBackFunction(true);
                                      _formKey.currentState!.reset();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: Color(0xffcd3a62),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                                  borderSide: BorderSide(color: Colors.black)),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              hintText: "Full Name",
                            ),
                            style: TextStyle(
                                fontSize: textScale > 1 ? 1.8*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier
                            ),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                      /*Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 20),
                    child: Container(
                        height: 80, child: Center(child: GenderSelector())),
                  ),*/
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}