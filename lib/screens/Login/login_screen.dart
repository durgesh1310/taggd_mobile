import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/widgets/CustomOTPSheet/custom_otp_sheet.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/screens/SignUp/sendOTP_state.dart';
import 'package:ouat/screens/SignUp/sendOTP_event.dart';
import 'package:ouat/screens/SignUp/sendOTP_bloc.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginScreen extends StatefulWidget {
  bool? cart;
  var callback;
  LoginScreen({this.callback, this.cart});
  static const ROUTE_NAME = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late SendOTPBloc sendOTPBloc = SendOTPBloc(SearchInitState());
  // var callBackFunction;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController signinId_controller = new TextEditingController();
  SendOTPModel? sendOTPModel = SendOTPModel();



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double textScale = MediaQuery.of(context).textScaleFactor;
    return BlocProvider(
      create: (context) => sendOTPBloc,
      child: BaseBlocListener(
          bloc: sendOTPBloc,
          listener: (context, state) {

            if (state is MessageState) {
              Fluttertoast.showToast(
                  msg: state.sendOTPModel!.message![0].msgText!,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Color(0xffcd3a62),
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }

            if (state is CompletedState) {
              sendOTPModel = state.sendOTPModel;
              _enterOTP(context).then((value) {
                if (value != null) {
                  // callBackFunction(value);

                }
              });
            }

            if (state is ErrorState) {
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
                return WillPopScope(
                  onWillPop: () async {
                    Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                    return false;
                  },
                  child: Scaffold(
                    body: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            widget.cart ?? false ? 'assets/image/checkoutLogin.jpg' : 'assets/image/login.jpg',
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
                              height: SizeConfig.screenHeight / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 30.0),
                                    child: SvgPicture.asset(
                                      widget.cart ?? false ? 'assets/icons/shopping.svg' : 'assets/icons/login.svg',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      'Proceed with your mobile',
                                      style: TextStyle(
                                          fontSize: textScale > 1 ? 2.8*SizeConfig.textMultiplier : 3*SizeConfig.textMultiplier,
                                          fontFamily: 'RecklessNeue',
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xff4B4B4B)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    'You will receive an OTP.',
                                    style: TextStyle(
                                      fontSize: textScale > 1 ? 1.8*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter'
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
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
                                        controller: signinId_controller,
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
                                                  sendOTPInitState();
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
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          top: 55,
                          left: 15,
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff4D4D4D).withOpacity(.8),
                                  borderRadius: BorderRadius.circular(24)
                              ),
                              child: Padding(
                                padding:  EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/image/icon-back-arrow.svg',
                                    ),
                                    Text(
                                      ' Go Back',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                );
              })),
    );
  }

  sendOTPInitState() async {
    sendOTPBloc.add(LoadEvent(signinId_controller.text.toString(), "LOGIN"));
  }

  Future _enterOTP(BuildContext ctx) async {
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        if (sendOTPModel!.data != null) {
          return CustomOTPSheet(
              "LOGIN", signinId_controller.text.toString(), sendOTPModel,
              (value) {
            if (value != null) {
              if (value) {
                Navigator.pop(ctx, value);
              } else {
                //
              }
            } else {}
          });
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xffcd3a62),
          ));
        }
      },
    ).then((value) {
      if (value != null) {
        widget.callback(true);
        Navigator.pop(context);
        // callBackFunction(value);
      }
    });
  }
}
