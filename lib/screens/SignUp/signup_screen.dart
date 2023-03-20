import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/screens/SignUp/user_details_screen.dart';
import 'package:ouat/screens/SignUp/user_email_screen.dart';
import 'package:ouat/screens/SignUp/user_mobile_screen.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/utility/constants.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './signup_state.dart';
import './signup_event.dart';
import './signup_bloc.dart';
import '../../size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/widgets/CustomOTPSheet/custom_otp_sheet.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';



class SignUpScreen extends StatefulWidget {
  static const ROUTE_NAME = 'SignUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentPage = 0;
  late SignUpBloc signUpBloc = SignUpBloc(SearchInitialState());
  PageController _pageController = PageController();
  SendOTPModel? sendOTPModel = SendOTPModel();
  late SharedPreferences userData;
  var registerationPayload;
  bool hide = false;
  var name, gender, email, mobno;

  @override
  void initState() {
    if(Platform.isIOS){
      askPermission();
    }
    initSharedPref();
  }

  void initSharedPref() async{
    userData = await SharedPreferences.getInstance();
    userData.setBool(Constants.SIGNUPACTIVITY, true);
  }

  // List<Widget> _pages = [
  //   UserDetails(),
  //   UserEmailScreen((value){

  //   }),
  //   UserMobileScreen()
  // ];

  _onChanged(int index){
    setState(() {
      _currentPage = index;
    });
  }// To change the page to next page

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => signUpBloc,
      child: BaseBlocListener(
          bloc: signUpBloc,
          listener: (context, state) {

            if(state is MessageState){
              Fluttertoast.showToast
                (
                  msg: state.sendOTPModel!.message![0].msgText!
              );
            }

            if(state is CompletedState){
              sendOTPModel = state.sendOTPModel;
              _enterOTP(context).then((value){
                if(value!=null){
                  //Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                }
                Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
              });
            }

            if (state is CompletedSignUpState) {

              if(state.signUpModel!.message![0].msgType != "INFO"){
                sendOTPInitState();
              }
              else{
                //SmartechPlugin().login("${state.signUpModel!.data}");
                name = (userData.getString('name') ?? "");
                gender = (userData.getString('gender') ?? "UNKNOWN");
                email = (userData.getString('email') ?? "");
                mobno = (userData.getString('mobile') ?? "");
                NetcoreEvents.registerationTrack(name, gender, email, mobno);
                AppsFlyer.registerationTrack(name, gender, email, mobno);
                Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
              }
            }


            if(state is ErrorSignUpState){
              Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
            }

          },
          child: BaseBlocBuilder(
              bloc: signUpBloc,
              condition: (oldState, currentState) {
                return !(BaseBlocBuilder.isBaseState(currentState));
              },
              builder: (BuildContext context, BaseState state) {

                return Scaffold(
                  body: Stack(
                    children: [
                      PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          onPageChanged: _onChanged,
                          itemBuilder: (context, int index){
                            return getBody(index);
                          }
                      ),
                      Positioned(
                        top: 48,
                        left: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff4D4D4D).withOpacity(.8),
                              borderRadius: BorderRadius.circular(24)
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(1.0),
                            child: TextButton(
                              onPressed: () {
                                // Navigator.of(context).(SplashActivity.ROUTE_NAME);
                                Navigator.pushReplacementNamed(context, SplashActivity.ROUTE_NAME);
                              },
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 14.88,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      hide ?
                      Container(height: 0,) :
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(3, (int index){
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: (index == _currentPage)? 10 : 6,
                              width: (index == _currentPage)? 10 : 6,
                              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: (index == _currentPage)? Color(0xff4D4D4D) : Color(0xffCFCFCF)
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                );
              })),
    );
  }

  signUpInitState() async {
    //print(email_controller.toString());
    name = (userData.getString('name') ?? "");
    gender = (userData.getString('gender') ?? "UNKNOWN");
    email = (userData.getString('email') ?? "");
    mobno = (userData.getString('mobile') ?? "");
    signUpBloc.add(LoadSignUpEvent(name,gender,email,mobno));
  }

  Widget getBody(int? localindex){
    switch (localindex) {
      case 0: return UserDetails((value){
        if(value !=null){
          if(!value){
            hide = true;
          }
          else{
            _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            hide = false;
          }
        }
      });



      case 1: return UserEmailScreen((value){
        if(value!=null){
          //_pageController.jumpToPage(2);
          _pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          // _pageController.animateTo(offset, duration: duration, curve: curve)
          if(mounted){
            setState(() {

            });
          }


        }


      });


      case 2: return UserMobileScreen((value){
        if(value!=null){
          signUpInitState();
          //_pageController.jumpToPage(2);
          //_pageController.animateToPage(2, duration: Duration(seconds: 1), curve: Curves.easeIn);
          // _pageController.animateTo(offset, duration: duration, curve: curve)
          if(mounted){
            setState(() {

            });
          }


        }
      });

      default: return Container();
    }
  }

  sendOTPInitState() async {
    mobno = (userData.getString('mobile') ?? "");
    signUpBloc.add(LoadEvent(mobno.toString(), "LOGIN"));
  }

  void askPermission() async{
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  Future _enterOTP(BuildContext ctx) async{
    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        if(sendOTPModel!.data != null){
          return CustomOTPSheet(
              "LOGIN",
              mobno.toString(),
              sendOTPModel,
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
      },
    ).then((value) {
      if(value!=null){
        Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
      }
    });
  }
}