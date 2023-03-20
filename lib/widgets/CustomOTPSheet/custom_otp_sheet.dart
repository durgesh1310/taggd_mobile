import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/CustomOTPSheet/custom_otp_sheet_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'custom_otp_sheet_event.dart';
import 'custom_otp_sheet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ouat/screens/SignUp/sendOTP_state.dart';
import 'package:ouat/screens/SignUp/sendOTP_event.dart';
import 'package:ouat/screens/SignUp/sendOTP_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class CustomOTPSheet extends StatefulWidget {
  String otpReason;
  String signinId;
  SendOTPModel? sendOTPModel;
  var callbackFunction;
  CustomOTPSheet(
      this.otpReason, this.signinId, this.sendOTPModel, this.callbackFunction);

  @override
  _CustomOTPSheetState createState() => _CustomOTPSheetState();
}

class _CustomOTPSheetState extends State<CustomOTPSheet> {
  late String code;
  late ValidateOTPBloc validateOTPBloc =
      ValidateOTPBloc(ValidateSearchInitState());
  late SendOTPBloc sendOTPBloc = SendOTPBloc(SearchInitState());
  late SharedPreferences userData;
  final TextEditingController otp_controller = new TextEditingController();
  ColorBuilder _solidColor = PinListenColorBuilder(Colors.white, Colors.white);
  ColorBuilder _strokeColor = PinListenColorBuilder(Colors.grey, Colors.black);
  var loggedIn;
  var payload;

  late Timer _timer;
  int _start = 30;

  void initSharedPref() async {
    userData = await SharedPreferences.getInstance();
    await PreferencesManager.init();
    // loggedIn = (userData.getBool('login') ?? true);
    loggedIn = PreferencesManager.getPref("login") ?? true;
    log(loggedIn.toString());
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    initSharedPref();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  firstLoginCreditsInitState() async {
    validateOTPBloc.add(FirstEvent());
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return BaseBlocListener(
      bloc: validateOTPBloc,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icons/logo_main.png",
              height: 100,
              width: 130,
            ),
            Center(
              child: Text(
                'OTP Verification',
                style: TextStyle(
                    fontFamily: 'RecklessNeue',
                    fontWeight: FontWeight.w400,
                    fontSize: textScale > 1 ? 3*SizeConfig.textMultiplier : 3.5*SizeConfig.textMultiplier),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  widget.sendOTPModel!.data!.notificationMessage ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textScale > 1 ? 1.8*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3 * SizeConfig.heightMultiplier),
              child: PinInputTextField(
                controller: otp_controller,
                autofillHints: [AutofillHints.oneTimeCode],
                pinLength: widget.sendOTPModel!.data!.otpLength!,
                keyboardType: TextInputType.number,
                autoFocus: true,
                enabled: true,
                cursor: Cursor(color: Color(0xffcd3a62)),
                onChanged: (String value) {
                  this.code = value;
                  if(value.length == widget.sendOTPModel!.data!.otpLength!){
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: BoxLooseDecoration(
                    gapSpace: 20,
                    strokeColorBuilder: _strokeColor,
                    bgColorBuilder: _solidColor,
                    textStyle: TextStyle(color: Colors.black, fontSize: 18)),

                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  this.code = verificationCode;
                  verificationCode = '';
                }, // end onSubmit
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3 * SizeConfig.heightMultiplier),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff0A0A0A)),
                  fixedSize: MaterialStateProperty.all(Size(SizeConfig.screenWidth, 50)),
                ),
                onPressed: () {
                  validateOTPInitState();
                  //CallBack is BaseListener
                  // widget.callbackFunction(true);
                },
                child: Text(
                    'Continue',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      fontSize: 18
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        'Did not receive an OTP?',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            fontSize: textScale > 1 ? 1.5*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                            color: Color(0xff4D4D4D)
                        ),
                      ),
                      if (_start > 0)
                        Text(
                          "$_start seconds to resend OTP",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              fontSize: textScale > 1 ? 1.2*SizeConfig.textMultiplier : 1.5*SizeConfig.textMultiplier,
                              color: Color(0xffBE4141)
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                    InkWell(
                      onTap: () {
                        if (_start > 0){
                          null;
                        }
                        else{
                          otp_controller.clear();
                          sendOTPInitState();
                          setState(() {
                            _start = 30;
                          });
                          startTimer();
                        }
                      },
                      child: Text(
                        "RESEND OTP",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            fontSize: textScale > 1 ? 1.8*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier,
                          color: _start > 0 ? Color(0xff4D4D4D) : Colors.black
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      listener: (BuildContext context, BaseState state) async {
        if (state is FirstLoginCreditsState) {
          if (state.addToCartModel!.message![0].msgText!.isNotEmpty) {
            Fluttertoast.showToast(
                msg: state.addToCartModel!.message![0].msgText!,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xffcd3a62),
                textColor: Colors.white,
                fontSize: 16.0);
          }

          widget.callbackFunction(true);
        }

        if (state is CompletedMergeState) {}

        if (state is OnceLoggedState) {
          //widget.callback(true);
        }
        if (state is CompletedValidateState) {
          if (state.validateOTPModel!.data == null) {
            widget.callbackFunction(true);
          } else {
            if (widget.otpReason == "LOGIN") {
              //  await getMergeState();
              if (state.validateOTPModel!.data!.customerDetail != null) {
                //TODO: Make a UserCommon
                if (loggedIn) {
                  firstLoginCreditsInitState();
                  //  userData.setBool('login', true);
                }
                userData.setString('name',
                    state.validateOTPModel!.data!.customerDetail!.firstName!);
                state.validateOTPModel!.data!.customerDetail!.gender == null
                    ? userData.setString('gender', "UNKNOWN")
                    : userData.setString('gender',
                        state.validateOTPModel!.data!.customerDetail!.gender!);
                state.validateOTPModel!.data!.customerDetail!.email == null
                    ? userData.setString('email', "")
                    : userData.setString('email',
                        state.validateOTPModel!.data!.customerDetail!.email!);
                state.validateOTPModel!.data!.customerDetail!.mobile == null
                    ? userData.setString('mobile', "")
                    : userData.setString('mobile',
                        state.validateOTPModel!.data!.customerDetail!.mobile!);
                userData.setString(
                    'token', state.validateOTPModel!.data!.token!);
                userData.setInt('customer_id',
                    state.validateOTPModel!.data!.customerDetail!.customerId!);
                log(state.validateOTPModel!.data!.customerDetail!.toString());
                SmartechPlugin().login(
                    state.validateOTPModel!.data!.customerDetail!.customerId.toString());
                AddToCartModel addToMergeCartModel =
                    await DataRepo.getInstance().userRepo.getMergeCart();

                log("$addToMergeCartModel");
                NetcoreEvents.loginTrack(
                    state.validateOTPModel!.data!.customerDetail!.firstName ??
                        "",
                    state.validateOTPModel!.data!.customerDetail!.gender ??
                        "UNKNOWN",
                    state.validateOTPModel!.data!.customerDetail!.email ?? "",
                    state.validateOTPModel!.data!.customerDetail!.mobile ??
                        "",
                    state.validateOTPModel!.data!.customerDetail!.customerId! );
                AppsFlyer.loginTrack(
                    state.validateOTPModel!.data!.customerDetail!.firstName ??
                        "",
                    state.validateOTPModel!.data!.customerDetail!.gender ??
                        "UNKNOWN",
                    state.validateOTPModel!.data!.customerDetail!.email ?? "",
                    state.validateOTPModel!.data!.customerDetail!.mobile ??
                        "",
                    state.validateOTPModel!.data!.customerDetail!.customerId! );
                widget.callbackFunction(true);
              } else {
                otp_controller.clear();
                setState(() {
                  _start = 30;
                });
                startTimer();
                Fluttertoast.showToast(
                    msg: "${state.validateOTPModel!.data!.notificationMessage}",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xffcd3a62),
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            } else {
              if (widget.signinId.length == 10) {
                userData.setString('mobile', widget.signinId);
              } else {
                userData.setString('email', widget.signinId);
              }
              widget.callbackFunction(true);
            }
          }
        }
      },
    );
  }

  validateOTPInitState() async {
    validateOTPBloc
        .add(OtpVerifyEvent(code, widget.signinId, widget.otpReason));
  }

  Future getMergeState() async {
    validateOTPBloc.add(MergeEvent());
  }

  sendOTPInitState() async {
    sendOTPBloc.add(LoadEvent(widget.signinId, widget.otpReason));
  }
}
