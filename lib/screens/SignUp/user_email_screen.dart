import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import 'package:ouat/widgets/CustomOTPSheet/custom_otp_sheet.dart';
import 'package:ouat/size_config.dart';
import './sendOTP_state.dart';
import './sendOTP_event.dart';
import './sendOTP_bloc.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEmailScreen extends StatefulWidget {
  var callBackFunction;
  UserEmailScreen(this.callBackFunction);

  @override
  _UserEmailScreenState createState() => _UserEmailScreenState();
}

class _UserEmailScreenState extends State<UserEmailScreen> {
  late SendOTPBloc sendOTPBloc = SendOTPBloc(SearchInitState());
  final TextEditingController email_controller = new TextEditingController();
  late SharedPreferences userData;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState()  {
    initSharedPref();
  }

  void initSharedPref() async{
    userData = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return BlocBuilder(
        bloc: sendOTPBloc,
        builder: (BuildContext context, dynamic state) {
          return Scaffold(
              body: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/image/mobile.webp',
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
                                'So stylish! So affordable! \n gold, diamond, silver, gems...',
                                style: TextStyle(
                                    fontSize: textScale > 1 ? 2.5*SizeConfig.textMultiplier : 3*SizeConfig.textMultiplier,
                                    fontFamily: 'RecklessNeue',
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xff4B4B4B)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 25, left: 40, right: 40),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter your email in the format: name@example.com';
                                    }
                                    else if(!value.contains(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))){
                                      return 'Enter your email in the format: name@example.com';
                                    }
                                    return null;
                                  },
                                  controller: email_controller,
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
                                            userData.setString('email', email_controller.text.toString().trim());
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
                                    hintText: "Email",
                                  ),
                                  style: TextStyle(
                                      fontSize: textScale > 1 ? 1.6*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier
                                  ),
                                  keyboardType: TextInputType.emailAddress,
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
    );
  }

  sendOTPInitState() async {
    //print(email_controller.toString());
    sendOTPBloc.add(LoadEvent(email_controller.text.toString().trim(), "PROFILE_UPDATE"));
  }

  Future _enterOTP(BuildContext ctx) async{
    await showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: BaseBlocListener(
              bloc: sendOTPBloc,
              listener: (ctx, state){
                if(state is ErrorState){
                  GeneralDialog.show(
                    context,
                    title: 'Error',
                    message: state.message,
                    closeOnAction: true,
                    positiveButtonLabel: 'OK',
                    onPositiveTap: () {
                      // Navigator.of(context).pop();
                      //      Navigator.of(context)
                      //          .pushNamed(AddressScreen.ROUTE_NAME, arguments: {
                      //        'selectMode': true,
                      //        'homeMode': true,
                      //      }).then((value) {
                      //        setState(() {
                      //          Address address = value;
                      //          _bloc.add(DefaultAddress(addressId: address.id));
                      //        });
                      //      });
                    },
                  );
                }
              },
              child: BaseBlocBuilder(
                  bloc: sendOTPBloc,
                  condition: (oldState, currentState) {
                    return !(BaseBlocBuilder.isBaseState(currentState));
                  },
                  builder: (BuildContext context, BaseState state) {
                    if(state is CompletedState){
                      return CustomOTPSheet(
                          "PROFILE_UPDATE",
                          email_controller.text.toString().trim(),
                          state.sendOTPModel,
                              (value){
                            if(value!=null){
                              if(value){
                                Navigator.pop(ctx,value);
                              }else{
                                //
                              }

                            }else{

                            }
                          }
                      );
                    }
                    else {
                      return Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffcd3a62),
                          )
                      );
                    }
                  }
              )
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    ).then((value) {
      if(value!=null){
        widget.callBackFunction(value);
      }
    });
  }
}