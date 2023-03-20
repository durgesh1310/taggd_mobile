import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/data/models/suggestionModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/screens/Account/account_screen.dart';
import 'package:ouat/screens/Account/help_screen.dart';
import 'package:ouat/screens/AppBar/appBar.dart';
import 'package:ouat/screens/Cart/cart_screen.dart';
import 'package:ouat/screens/Category/category_screen.dart';
import 'package:ouat/screens/Checkout/checkout_screen.dart';
import 'package:ouat/screens/Home/home_screen.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/OrderListing/order_listing_screen.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/screens/SearchComponent/suggestion_widget.dart';
import 'package:ouat/screens/SpecialPage/specialPage_screen.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/upgrader_src/upgrader.dart';
import 'package:ouat/utility/upgrader_src/upgrader_screen.dart';
import 'package:ouat/widgets/badge.dart';
import 'package:ouat/widgets/custom_bottomBar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ouat/main.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';


class BottomBarActivity extends StatefulWidget {
  HomeModel? homeModel;
  SortBarModel? sortBarModel;
  OrderStatusModel? orderStatusModel;

  BottomBarActivity({this.homeModel, this.sortBarModel, this.orderStatusModel});
  @override
  _BottomBarActivityState createState() => _BottomBarActivityState();
}

class _BottomBarActivityState extends State<BottomBarActivity>{
  int _selectedIndex = 0;
  final _inactiveColor = Colors.grey;
  bool searching = false;
  final TextEditingController _filter = new TextEditingController();
  SuggestionModel? suggestionModel;
  int? count = 0;
  bool isDeepLink = true;
  DataRepo dataRepo = DataRepo.getInstance();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'No',
            style: TextStyle(
                color: Color(0xffcd3a62)
            ),
          ),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(),
          child: Text(
            'Yes',
            style: TextStyle(
                color: Color(0xffcd3a62)
            ),
          ),
        ),
      ],
    );
  }


  @override
  void initState() {
    checkUpdate();
    (widget.orderStatusModel!.data != null)
        ? count = widget.orderStatusModel!.data
        : count = 0;
    AppsFlyer.appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true
    );
    WidgetsBinding.instance!
        .addPostFrameCallback((_){
      deepLinkingRouting();
    });
    super.initState();
  }

  deeplinkInBackground(String? deepLinkValue, String? deepLinkSub1) {
    CustomerDetail? customerDetail =
    dataRepo.userRepo
        .getSavedUser();
    if(deepLinkValue != null){
      if(deepLinkValue == "PLP"){
        Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
            arguments: {
              "query": "",
              "id": "${deepLinkSub1}",
              "collection": false,
            });
      }
      else if(deepLinkValue == "PDP"){
        Navigator.pushNamed(
          context,
          ProductDescriptionScreen.ROUTE_NAME,
          arguments: {
            "pid": '${deepLinkSub1}'
          },
        );
      }
      else if(deepLinkValue == "COLLECTION"){
        Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
            arguments: {
              "query": "",
              "id": "${deepLinkSub1}",
              "collection": true,
            });
      }
      else if(deepLinkValue == "SP"){
        Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
            arguments: {
              "id": "${deepLinkSub1}",
            });
      }
      else if(deepLinkValue == "CART"){
        _onItemTapped(2);
      }
      else if(deepLinkValue == "ACCOUNT"){
        _onItemTapped(3);
      }
      else if(deepLinkValue == "ORDERS"){
        if(customerDetail != null){
          Navigator.pushNamed(context, OrderListingScreen.ROUTE_NAME);
        }
        else{
          Navigator.pushNamed(context, LoginScreen.ROUTE_NAME,
              arguments: {
                "callback": (value) {
                  if (value != null) {

                  }
                }
              });
        }
      }
      else if(deepLinkValue == "CHECKOUT"){
        if(customerDetail != null){
          Navigator.pushNamed(
              context,
              CheckOutScreen
                  .ROUTE_NAME,
              arguments: {
                "promocode": ""
              });
        }
        else{
          Navigator.pushNamed(context, LoginScreen.ROUTE_NAME,
              arguments: {
                "callback": (value) {
                  if (value != null) {

                  }
                }
              });
        }
      }
    }
  }

  deepLinkingRouting() async {
    SmartechPlugin().onhandleDeeplinkActionBackground();
    SmartechPlugin().handleDeeplinkAction((String? link, Map<dynamic, dynamic>? map, bool? isAfterTerminated) {
      log(map.toString());
      deeplinkInBackground(map!['deepLinkValue'], map['deepLinkSub1']);
      // Handle the deeplink
    });
    CustomerDetail? customerDetail =
    dataRepo.userRepo
        .getSavedUser();
    if(MyApp.deepLinkModel != null){
      if(MyApp.deepLinkModel!.deepLinkValue == "PLP"){
        Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
            arguments: {
              "query": "",
              "id": "${MyApp.deepLinkModel!.deepLinkSub1}",
              "collection": false,
            });
      }
      else if(MyApp.deepLinkModel!.deepLinkValue == "PDP"){
        Navigator.pushNamed(
          context,
          ProductDescriptionScreen.ROUTE_NAME,
          arguments: {
            "pid": '${MyApp.deepLinkModel!.deepLinkSub1}'
          },
        );
      }
      else if(MyApp.deepLinkModel!.deepLinkValue == "COLLECTION"){
        Navigator.pushNamed(context, SearchScreen.ROUTE_NAME,
            arguments: {
              "query": "",
              "id": "${MyApp.deepLinkModel!.deepLinkSub1}",
              "collection": true,
            });
      }
      else if(MyApp.deepLinkModel!.deepLinkValue == "SP"){
        Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
            arguments: {
              "id": "${MyApp.deepLinkModel!.deepLinkSub1}",
            });
      }
      else if(MyApp.deepLinkModel!.deepLinkValue == "CART"){
        _onItemTapped(2);
      }
      else if(MyApp.deepLinkModel!.deepLinkValue == "ACCOUNT"){
        _onItemTapped(3);
      }
      else if(MyApp.deepLinkModel!.deepLinkValue == "ORDERS"){
        if(customerDetail != null){
          Navigator.pushNamed(context, OrderListingScreen.ROUTE_NAME);
        }
        else{
          Navigator.pushNamed(context, LoginScreen.ROUTE_NAME,
              arguments: {
                "callback": (value) {
                  if (value != null) {

                  }
                }
              });
        }
        }
      else if(MyApp.deepLinkModel!.deepLinkValue == "CHECKOUT"){
       if(customerDetail != null){
         Navigator.pushNamed(
             context,
             CheckOutScreen
                 .ROUTE_NAME,
             arguments: {
               "promocode": ""
             });
       }
       else{
         Navigator.pushNamed(context, LoginScreen.ROUTE_NAME,
             arguments: {
               "callback": (value) {
                 if (value != null) {

                 }
               }
             });
       }
      }
    }
  }




  @override
  Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (context) => _buildExitDialog(context),
          );
        },
        child: Scaffold(
          bottomNavigationBar: CustomAnimatedBottomBar(
            onItemSelected: _onItemTapped,
            containerHeight: 75,
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex,
            showElevation: true,
            itemCornerRadius: 24,
            curve: Curves.easeIn,
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/home.svg',
                  height: 24,
                  width: 24,
                ),
                title: Text(
                  'Taggd',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.88,
                      color: Color(0xff0A0A0A),
                      fontWeight: FontWeight.w500
                  ),
                ),
                activeColor: Color(0xffFAD1D8),
                inactiveColor: _inactiveColor,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 1 ? 'assets/icons/productsFill.svg' :
                  'assets/icons/products.svg',
                  height: 26,
                  width: 26,
                ),
                title: Text(
                  'Products',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.88,
                      color: Color(0xff0A0A0A)
                  ),
                ),
                activeColor: Color(0xffFAD1D8),
                inactiveColor: _inactiveColor,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: Badge(
                    SvgPicture.asset(
                      _selectedIndex == 2 ?
                      'assets/icons/bagFill.svg' :
                      'assets/icons/bag.svg',
                      height: 26,
                      width: 26,
                    ),
                    (count != null && count! > 0) ? count.toString() : "",
                    Color(0xffcd3a62),
                    8,
                    1
                ),
                title: Text(
                  'Bag',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.88,
                      color: Color(0xff0A0A0A)
                  ),
                ),
                activeColor: Color(0xffFAD1D8),
                inactiveColor: _inactiveColor,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: SvgPicture.asset(
                  _selectedIndex == 3 ?
                  'assets/icons/profileFill.svg' :
                  'assets/icons/profile.svg',
                  height: 24,
                  width: 24,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.88,
                      color: Color(0xff0A0A0A)
                  ),
                ),
                activeColor: Color(0xffFAD1D8),
                inactiveColor: _inactiveColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          body: Container(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.055
                  ),
                  child: getBody(),
                ),
                (!searching)
                    ? Positioned(
                  child: AppBarCustom(
                    onTapSearch: (bool val) {
                      setState(() {
                        searching = val;
                      });
                    },
                    callback: updateCartItem,
                    screen: "Home",
                  ),
                  top: 0,
                )
                    : SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: SearchListItem(
                    onTapSearch: (bool value) {
                      setState(() {
                        searching = value;
                      });
                    },
                    callback: updateCartItem,
                    screen: "Home",
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  @override
  void didUpdateWidget(BottomBarActivity oldWidget) {
    // updateCartItem();

    super.didUpdateWidget(oldWidget);
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeActivity(
          homeModel: widget.homeModel,
          sortBarModel: widget.sortBarModel,
          callback: updateCartItem,
        );

      case 1:
        return CategoryActivity(
          sortBarModel: widget.sortBarModel,
          callback: updateCartItem,
        );

      case 2:
        return CartActivity(
          callback: updateCartItem,
        );

      case 3:
        return AccountActivity(
          callback: updateCartItem,
        );

      case 4:
        return HelpScreen(
            callback: (value){
              _onItemTapped(3);
            }
        );

      default:
        return Container();
    }
  }

  void updateCartItem(bool value) async {
    if(value){
      OrderStatusModel? orderStatusModel = await DataRepo.getInstance().userRepo.getItemsNumber();
      print(orderStatusModel.data);
      setState(() {
        count = orderStatusModel.data;
      });
    }
    else{
      _onItemTapped(4);
    }
  }

  Future<void> _launchInWebView(String url) async {
    if (await canLaunch('$url')) {
      await launch(
        '$url',
      );
    } else {
      throw 'Could not launch url';
    }
  }

  void checkUpdate() async{
    if(Platform.isAndroid){
      final newVersion = NewVersion(
        androidId: "com.ouat.taggd",
      );
      final status = await newVersion.getVersionStatus();
      if(status!.storeVersion != status.localVersion){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AppUpdatedScreen(
                  versionName: status.storeVersion,
                  whatsNew: status.releaseNotes,
                  onCallback: () {
                    _launchInWebView("https://play.google.com/store/apps/details?id=com.ouat.taggd");
                    //onUserUpdated(context, !blocked());
                  },
                )));
      }
      }
      await Upgrader().initialize();
      Upgrader().checkVersion(context: context);
  }
}