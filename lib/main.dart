import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ouat/data/models/deepLinkModel.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import 'package:ouat/screens/Account/account_screen.dart';
import 'package:ouat/screens/Account/select_address_screen.dart';
import 'package:ouat/screens/Cart/cart_screen.dart';
import 'package:ouat/screens/Checkout/banks_screen.dart';
import 'package:ouat/screens/Checkout/checkout_screen.dart';
import 'package:ouat/screens/Checkout/shipping_address_screen.dart';
import 'package:ouat/screens/Checkout/update_address_screen.dart';
import 'package:ouat/screens/OrderConfirmation/order_confirmation_screen.dart';
import 'package:ouat/screens/OrderDescription/order_description_screen.dart';
import 'package:ouat/screens/OrderListing/order_listing_screen.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:ouat/screens/Promo/promo_screen.dart';
import 'package:ouat/screens/ScratchCard/scratch_card_screen.dart';
import 'package:ouat/screens/Search/search_screen.dart';
import 'package:ouat/screens/SpecialPage/specialPage_screen.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/screens/WishList/wishlist_screen.dart';
import 'package:ouat/utility/constants.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/widgets/Filters/filters_screen.dart';
import 'screens/Login/login_screen.dart';
import 'screens/SignUp/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:flutter/services.dart' show PlatformException;
//demo push



final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  print("Our background job ran!");
}




void main() async {
  Constants.isDebugMode();
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  static DeepLinkModel? deepLinkModel = DeepLinkModel();
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp>  with WidgetsBindingObserver{
  UserRepo userRepo = UserRepo();
  late SharedPreferences deeplinkData;
  var first;
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  DataRepo dataRepo = DataRepo.getInstance();



  @override
  // ignore: must_call_super
  void initState() {
    deeplinkInitialization();
    firebasemsg();
    AppsFlyer.appsflyerSdk.onInstallConversionData((res){
      print("res: " + res.toString());
    });
    AppsFlyer.appsflyerSdk.onAppOpenAttribution((res){
      print("res: " + res.toString());
    });
    AppsFlyer.appsflyerSdk.onDeepLinking((res) {
      print("res: " + res.toString());
    });
    WidgetsBinding.instance!.addObserver(this);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getUserData();
    });

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        log("app in resumed");
        SmartechPlugin().onhandleDeeplinkActionBackground();
        deeplinkInBackground();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }


  void firebasemsg() async {
    // FirebaseCrashlytics.instance.crash();

    if (Platform.isAndroid) {
      var token = await FirebaseMessaging.instance.getToken();
      SmartechPlugin().setDevicePushToken(token!);

      FirebaseMessaging.onMessage.listen((event) {
        if (event != null) {
          if (event.data != null) {
            SmartechPlugin().handlePushNotification(event.data.toString());
          }
        }
      });

//This method for to handle background notification



      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }
  }





  deeplinkInBackground() {
    AppsFlyer.appsflyerSdk.onDeepLinking((DeepLinkResult dp) async {
      switch (dp.status) {
        case Status.FOUND:
          if(Platform.isIOS){
            deepLinkingRouting(dp.deepLink!.deepLinkValue, dp.deepLink!.getStringValue("deep_link_sub1"));
          }
          else{
            MyApp.deepLinkModel = DeepLinkModel.fromJson(dp.deepLink?.clickEvent ?? {});
          }
          break;
        case Status.NOT_FOUND:
          log("deep link not found");
          break;
        case Status.ERROR:
          log("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          log("deep link status parsing error");
          break;
      }
    });
  }

  deeplinkInitialization() {
    AppsFlyer.appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          deepLinkingRouting(dp.deepLink!.deepLinkValue, dp.deepLink!.getStringValue("deep_link_sub1"));
          break;
        case Status.NOT_FOUND:
          log("deep link not found");
          break;
        case Status.ERROR:
          log("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          log("deep link status parsing error");
          break;
      }
    });
  }


  deepLinkingRouting(String? deepLinkValue, String? deepLinkSub1) {
    CustomerDetail? customerDetail =
    dataRepo.userRepo
        .getSavedUser();
    if(deepLinkValue != null){
      if(deepLinkValue == "PLP"){
        navigatorKey.currentState!.pushNamed(
            SearchScreen.ROUTE_NAME,
            arguments: {
              "query": "",
              "id": "${deepLinkSub1}",
              "collection": false,
            });
      }
      else if(deepLinkValue == "PDP"){
        navigatorKey.currentState!.pushNamed(
          ProductDescriptionScreen.ROUTE_NAME,
          arguments: {
            "pid": '${deepLinkSub1}',
          },);
      }
      else if(deepLinkValue == "COLLECTION"){
        navigatorKey.currentState!.pushNamed(
          SearchScreen.ROUTE_NAME,
          arguments: {
            "query": "",
            "id": "${deepLinkSub1}",
            "collection": true,
          },);
      }
      else if(deepLinkValue == "SP"){
        navigatorKey.currentState!.pushNamed(
          SpecialPage.ROUTE_NAME,
          arguments: {
            "id": "${deepLinkSub1}",
          },);
      }
      else if(deepLinkValue == "CART"){
        //_onItemTapped(2);
        navigatorKey.currentState!.pushNamed(
            CartActivity.ROUTE_NAME,
            arguments: {
              "callback": (value) {
                if (value) {
                  //countCartItems();
                }
              },
              "pdp": true
            });
      }
      else if(deepLinkValue == "ACCOUNT"){
        //_onItemTapped(3);
      }
      else if(deepLinkValue == "ORDERS"){
        if(customerDetail != null){
          navigatorKey.currentState!.pushNamed(OrderListingScreen.ROUTE_NAME);
        }
        else{
          navigatorKey.currentState!.pushNamed(LoginScreen.ROUTE_NAME,
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
          navigatorKey.currentState!.pushNamed(
              CheckOutScreen
                  .ROUTE_NAME,
              arguments: {
                "promocode": ""
              });
        }
        else{
          navigatorKey.currentState!.pushNamed(LoginScreen.ROUTE_NAME,
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

  getUserData() async {
    CustomerDetail? customerDetail =
    await DataRepo.getInstance().userRepo.getSavedUser();
    log("$customerDetail");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'taggd',
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 26.66,
              fontFamily: 'RecklessNeue',
              fontWeight: FontWeight.w300,
              color: Color(0xff4B4B4B)),
          //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: SplashActivity.ROUTE_NAME,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case LoginScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(LoginScreen(
              cart: data['cart'],
              callback: data['callback'],
            ));

          case SplashActivity.ROUTE_NAME:
            return _getDefaultRoute(SplashActivity());

          case SignUpScreen.ROUTE_NAME:
            return _getDefaultRoute(SignUpScreen());

          case BankScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(BankScreen(
              bank: data['bank'],
              callback: data['callback'],
            ));

          case SelectAccountAddressScreen.ROUTE_NAME:
            return _getDefaultRoute(SelectAccountAddressScreen());

          case SpecialPage.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(SpecialPage(
                id: data['id'],
                callback: data['callback']
            ));

          case FiltersScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(FiltersScreen(
              filters: data['filters'],
            ));

          case OrderListingScreen.ROUTE_NAME:
            return _getDefaultRoute(OrderListingScreen());

          case PromoScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(PromoScreen(
              cart_items: data['cart_items'],
              cart_value: data['cart_value'],
              callback: data['callback'],
            ));

          case WishListScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(WishListScreen(
              callback: data['callback'],
            ));

          case CheckOutScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(CheckOutScreen(
              promocode: data['promocode'],
            ));

          case ShippingAddressScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(ShippingAddressScreen(
              callback: data['callback'],
            ));

          case CartActivity.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(CartActivity(
              callback: data['callback'],
              pdp: data['pdp'],
            ));

          case SearchScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(SearchScreen(
              query: data['query'],
              id: data['id'],
              collection: data['collection'],
              callback: data['callback'],
            ));

          case UpdateAddressScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(UpdateAddressScreen(
              data: data['data'],
              pin: data['pin'],
              callback: data['callback'],
            ));

          case ProductDescriptionScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(ProductDescriptionScreen(
              pid: data['pid'],
              callback: data['callback'],
            ));

          case OrderDescriptionScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(OrderDescriptionScreen(
              order_number: data['order_number'],
              callback: data['callback'],
            ));

          case AccountActivity.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(AccountActivity(
                callback: data['callback']
            ));

          case OrderConfirmationScreen.ROUTE_NAME:
            Map data = settings.arguments as Map<dynamic, dynamic>;
            return _getDefaultRoute(OrderConfirmationScreen(
              order_id: data['order_id'],
            ));

          case ScratchCardScreen.ROUTE_NAME:
            return _getDefaultRoute(ScratchCardScreen());

          default:
            return _getDefaultRoute(SplashActivity());
        }
      },
    );
  }

  static Route _getDefaultRoute(Widget widget) {
    return MaterialPageRoute(builder: (BuildContext context) {
      return widget;
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  log("${message.data.toString()} message");
  await Firebase.initializeApp();
  SmartechPlugin().handlePushNotification(message.data.toString());
}


