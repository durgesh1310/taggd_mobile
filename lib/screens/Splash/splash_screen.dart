import 'package:flutter/material.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/screens/BottomBar/bottomBar_screen.dart';
import 'package:ouat/screens/SignUp/signup_screen.dart';
import 'package:ouat/screens/Splash/splash_bloc.dart';
import 'package:ouat/screens/Splash/splash_event.dart';
import 'package:ouat/screens/Splash/splash_state.dart';
import 'package:ouat/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SplashActivity extends StatefulWidget {
  static const ROUTE_NAME = 'SplashScreen';

  @override
  _SplashActivityState createState() => _SplashActivityState();
}

class _SplashActivityState extends State<SplashActivity> {
  SplashActivityBloc splashActivityBloc = SplashActivityBloc(InitialState());
  late SharedPreferences logInData;
  bool isInternetDisconnected = false;

  @override
  void initState() {
    getInitState();
    super.initState();
  }


  getInitState() async {
    splashActivityBloc.add(LoadAssetsEvent());
  }

  getCategoryState() async {
    splashActivityBloc.add(LoadCategoryEvent());
  }

  checkLoginState() async {
    splashActivityBloc.add(LoadCheckLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseBlocListener(
        bloc: splashActivityBloc,
        listener: (context, state) {
          if (state is DoneState) {
            checkLoginState();
            if (state.boolisSignUpScreen ?? false) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBarActivity(
                    homeModel: state.homeModel,
                    sortBarModel: state.sortBarModel,
                    orderStatusModel: state.orderStatusModel,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(),
                ),
              );
            }
            getCategoryState();
          }

          if (state is ErrorState) {
            this.isInternetDisconnected = true;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Color(0xffcd3a62),
              duration: Duration(seconds: 3),
              content: Text(
                  state.message,
                style: TextStyle(color: Colors.white),
              ),
              action: SnackBarAction(
                label: 'Undo',
                textColor: Colors.white,
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            ));
          }
          // if(state is SignupDone){

          // }
          /*if(state is NotAuthorisedState){
            Navigator.pushNamed(context, LoginScreen.ROUTE_NAME);
          }*/
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/taggd_new_logo.png",//splashlogo.png",
                  ),
                  SizedBox(height: 10.0),
                  (!this.isInternetDisconnected)
                      ? SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            color: Color(0xffcd3a62),
                          ))
                      : Container()
                ],
              ),
            ),
            (this.isInternetDisconnected)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffcd3a62),
                            minimumSize: Size(SizeConfig.screenWidth,
                                5 * SizeConfig.heightMultiplier)),
                        onPressed: () async {
                          this.isInternetDisconnected = false;
                          setState(() {});
                          splashActivityBloc =
                              SplashActivityBloc(InitialState());

                          getInitState();
                        },
                        child: Text(
                          'Please Retry again',
                          style: TextStyle(
                              fontFamily: 'RecklessNeue',
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
