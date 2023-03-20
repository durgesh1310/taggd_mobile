import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import '../../size_config.dart';
import './sendOTP_state.dart';
import './sendOTP_event.dart';
import './sendOTP_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMobileScreen extends StatefulWidget {
  var callBackFunction;
  UserMobileScreen(this.callBackFunction);

  @override
  _UserMobileScreenState createState() => _UserMobileScreenState();
}

class _UserMobileScreenState extends State<UserMobileScreen> {
  late SendOTPBloc sendOTPBloc = SendOTPBloc(SearchInitState());
  final TextEditingController mob_controller = new TextEditingController();
  late SharedPreferences userData;
  final _formKey = GlobalKey<FormState>();
  SendOTPModel? sendOTPModel = SendOTPModel();



  @override
  void initState() {
    initSharedPref();
  }

  void initSharedPref() async{
    userData = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/image/email.webp',
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
                        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 10),
                        child: Text(
                          'Style up your home \n dining, living, lighting... ',
                          style: TextStyle(
                              fontSize: textScale > 1 ? 2.8*SizeConfig.textMultiplier : 3*SizeConfig.textMultiplier,
                              fontFamily: 'RecklessNeue',
                              fontWeight: FontWeight.w300,
                              color: Color(0xff4B4B4B)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 25, left: 50, right: 50),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Your mobile number must be 10 digit.';
                              }
                              else if(!RegExp(r'(^[0-9]{10}$)').hasMatch("$value")){
                                return 'Your mobile number must be 10 digit.';
                              }
                              return null;
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            controller: mob_controller,
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
                                    if(_formKey.currentState!.validate()){
                                      userData.setString('mobile', mob_controller.text.toString());
                                      widget.callBackFunction(true);
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
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  borderSide: BorderSide(color: Colors.black)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                              hintText: "10-digit mobile number",
                                hintStyle: TextStyle(
                                    fontSize: textScale > 1 ? 1.8*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier
                                )
                            ),
                            style: TextStyle(
                                fontSize: textScale > 1 ? 1.8*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier
                            ),
                            keyboardType: TextInputType.phone,
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
        )
    );
  }
}