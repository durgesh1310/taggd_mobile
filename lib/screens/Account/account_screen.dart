import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/customerCreditsModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/screens/Account/account_bloc.dart';
import 'package:ouat/screens/Account/select_address_screen.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/OrderListing/order_listing_screen.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/utility/constants.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import '../../size_config.dart';
import 'account_event.dart';
import 'account_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';




class AccountActivity extends StatefulWidget {
  static const ROUTE_NAME = 'AccountScreen';
   final ValueChanged<bool>? callback;
   AccountActivity({this.callback});

  @override
  State<AccountActivity> createState() => _AccountActivityState();
}

class _AccountActivityState extends State<AccountActivity> {
  AccountBloc accountBloc = AccountBloc(InitialState());
  var name;
  var email;
  var mobile;
  var _expandCredits = false;
  var _expandHelp = false;
  CustomerCreditsModel? customerCreditsModel = CustomerCreditsModel();
  late SharedPreferences userData;
  CustomerDetail? customerDetail = CustomerDetail();
  var screen;

  @override
  void initState() {
    getInitState();
    super.initState();
  }

  getInitState() async {
    accountBloc.add(LoadEvent());
    await PreferencesManager.init();
    log(email.toString());
    userData = await SharedPreferences.getInstance();
    email = (userData.getString('email') ?? '');
    mobile = (userData.getString('mobile') ?? '');
  }

  deleteUser() async{
    accountBloc.add(DeleteEvent());
  }

  allClear() async{
    await userData.clear();
    PreferencesManager.clean();
    await PreferencesManager.init();
    PreferencesManager.savePref(Constants.SIGNUPACTIVITY, true);
    PreferencesManager.savePref('login', false);
    var loggedIn = PreferencesManager.getPref("login");
    log(loggedIn.toString());

  }

  Future<void> _launchInWebView(String url) async {
    if (await canLaunch('$url')) {
      await launch(
        '$url',
        //forceWebView: true,
        //forceSafariVC: true,
        //enableJavaScript: true,
        //headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch url';
    }
  }


  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: BlocProvider(
        create: (context) => accountBloc,
        child: BaseBlocListener(
          bloc: accountBloc,
          listener: (context, state) {
            if (state is AuthorisedState) {
              name = state.name;
              email = state.email;
              email = (userData.getString('email') ?? '');
              mobile = state.mobile;
              customerCreditsModel = state.customerCreditsModel;
              NetcoreEvents.netcoreScreen("Account");
            }
            if(state is NotAuthorisedState){
              Navigator.pushNamed(context, LoginScreen.ROUTE_NAME, arguments: {
                "callback": (value){
                }
              }).then((value) {
                 getInitState();
                 widget.callback!(true);

              });
            }
            if(state is DeleteState){
              SmartechPlugin().clearUserIdentity();
              allClear();
              AppsFlyer.logoutTrack();
              NetcoreEvents.logoutTrack();
              Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
            }

            if(state is ErrorState){
              GeneralDialog.show(
                context,
                title: 'Error',
                message: state.message,
                closeOnAction: true,
                positiveButtonLabel: 'OK',
                onPositiveTap: () {
                },
              );
            }
          },
          child: BaseBlocBuilder(
              bloc: accountBloc,
              condition: (oldState, currentState) {
                return !(BaseBlocBuilder.isBaseState(currentState));
              },
              builder: (BuildContext context, BaseState state) {

                if (customerCreditsModel!.data != null) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding:  EdgeInsets.only(top: 90.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(name != null || name != "")
                          Padding(
                            padding: EdgeInsets.only(left: 15, bottom: 30),
                            child:
                            Text(
                              'Hello, $name',
                              style: TextStyle(
                                fontFamily: 'RecklessNeue',
                                fontSize: 2.5*SizeConfig.textMultiplier,
                              ),
                            ),
                          ),
                          email.toString().isNotEmpty ?
                            Padding(
                              padding:  EdgeInsets.only(left: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EMAIL',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 1.5*SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff4D4D4D)
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${email.toString()}',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 1.9*SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff0A0A0A)
                                    ),
                                  ),
                                  Divider(
                                    color: Color(0xffCFCFCF),
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            ) : Container(),
                          mobile.toString().isNotEmpty ?
                          Padding(
                            padding:  EdgeInsets.only(left: 15,bottom: 15, top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MOBILE',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 1.5*SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w600,
                                      color: Color(0xff4D4D4D)
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$mobile',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 2*SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w500,
                                      color: Color(0xff0A0A0A)
                                  ),
                                ),
                                Divider(
                                  color: Color(0xffCFCFCF),
                                  thickness: 2,
                                ),
                              ],
                            ),
                          ) : Container(),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, OrderListingScreen.ROUTE_NAME);
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/icons/orders.svg',
                                        height: 60,
                                        width: 60,
                                      ),
                                    iconSize: 60,
                                  ),
                                  Text(
                                    'My Orders',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: textScale >1 ? 1.7*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (customerCreditsModel!.data!.length > 0)
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          showCupertinoDialog<String>(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext
                                            context) =>
                                                CupertinoAlertDialog(
                                                  title: SvgPicture.asset(
                                                    'assets/icons/credits.svg',
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                  content: Container(
                                                    height: textScale >1 ? 60 * customerCreditsModel!.data!.length.toDouble() : 50 * customerCreditsModel!.data!.length.toDouble(),
                                                    child: Material(
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          padding: const EdgeInsets.only(bottom: 25),
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemCount: customerCreditsModel!.data!.length,
                                                          itemBuilder: (context, index) {
                                                            return ListTile(
                                                              title: Text(
                                                                '${customerCreditsModel!.data![index].creditName}:',
                                                                style: TextStyle(
                                                                  fontFamily: 'RecklessNeue',
                                                                  fontSize: textScale >1 ? 1.5*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              trailing: Text(
                                                                '₹${customerCreditsModel!.data![index].amount!.round()}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Inter',
                                                                  fontSize: textScale >1 ? 1.5*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/credits.svg',
                                          height: 60,
                                          width: 60,
                                        ),
                                      iconSize: 60,
                                    ),
                                    Text(
                                      'Store Credits',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: textScale >1 ? 1.7*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, SelectAccountAddressScreen.ROUTE_NAME);
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/icons/address.svg',
                                        height: 60,
                                        width: 60,
                                      ),
                                    iconSize: 60,
                                  ),
                                  Text(
                                    'My Address',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: textScale >1 ? 1.7*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Divider(
                            color: Color(0xffCFCFCF),
                            thickness: 2,
                          ),
                          ExpansionTile(
                            onExpansionChanged: (value){
                              setState(() {
                                _expandHelp = !_expandHelp;
                              });
                            },
                            title: Text(
                              'Policies',
                              style: TextStyle(
                                  fontFamily: 'RecklessNeue',
                                  fontSize: 2*SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                  color: _expandHelp ? Color(0xffcd3a62) : Colors.black
                              ),
                            ),
                            children: <Widget>[
                              ListTile(
                                onTap: (){
                                  _launchInWebView('https://www.taggd.com/shipping-policy');
                                },
                                title: Text(
                                  'Shipping Policy',
                                  style: TextStyle(
                                    fontFamily: 'RecklessNeue',
                                    fontSize: 2*SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(
                                    Icons.arrow_forward_ios
                                ),
                              ),
                              ListTile(
                                onTap: (){
                                  _launchInWebView('https://www.taggd.com/cancellation-return');
                                },
                                title: Text(
                                  'Cancellation & Return',
                                  style: TextStyle(
                                    fontFamily: 'RecklessNeue',
                                    fontSize: 2*SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(
                                    Icons.arrow_forward_ios
                                ),
                              ),
                              ListTile(
                                onTap: (){
                                  _launchInWebView('https://www.taggd.com/terms-conditions');
                                },
                                title: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    fontFamily: 'RecklessNeue',
                                    fontSize: 2*SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(
                                    Icons.arrow_forward_ios
                                ),
                              ),
                              ListTile(
                                onTap: (){
                                  _launchInWebView('https://www.taggd.com/privacy-policy');
                                },
                                title: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontFamily: 'RecklessNeue',
                                    fontSize: 2*SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(
                                    Icons.arrow_forward_ios
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Color(0xffCFCFCF),
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            onTap: (){
                              widget.callback!(false);
                            },
                            title: Text(
                              'Help',
                              style: TextStyle(
                                fontFamily: 'RecklessNeue',
                                fontSize: 2*SizeConfig.textMultiplier,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              'assets/icons/help.svg',
                              height: 26,
                              width: 26,
                            ),
                          ),
                          Divider(
                            color: Color(0xffCFCFCF),
                            thickness: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: () async {
                                  SmartechPlugin().clearUserIdentity();
                                  await allClear();
                                  AppsFlyer.logoutTrack();
                                  NetcoreEvents.logoutTrack();
                                  Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/logout.svg',
                                      height: 24,
                                      width: 24,
                                      color: Colors.white,
                                    ),
                                    Text(
                                        'Log Out',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if(Platform.isIOS)
                            Center(
                              child: ElevatedButton(
                                  onPressed: ()  {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext
                                      context) =>
                                          AlertDialog(
                                            title: Text(
                                              'Delete Account',
                                              style: TextStyle(
                                                  fontFamily:
                                                  'RecklessNeue',
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  fontSize: 2.5 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            ),
                                            content: const Text(
                                              'Are you sure to delete your account?',
                                              style: TextStyle(
                                                fontFamily:
                                                'Inter',
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Color(0xffcd3a62)
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: ()  {
                                                  deleteUser();
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Color(0xffcd3a62)
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xffF0F0F0),
                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Delete Account',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff0A0A0A),
                                    ),
                                  )
                              ),
                            ),
                          if(Platform.isIOS)
                            SizedBox(
                              height: 10,
                            ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              })
        ),
      )
    );
  }
}
