import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/message.dart';
import 'package:ouat/data/models/shippingChargesModel.dart';
import 'package:ouat/data/models/showCartModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/screens/Cart/cart_bloc.dart';
import 'package:ouat/screens/Checkout/checkout_screen.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/Promo/promo_screen.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/screens/WishList/wishlist_screen.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/CartItem/cartItem_screen.dart';
import 'package:ouat/widgets/message_screen.dart';
import 'package:ouat/widgets/order_summary.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/commonBannerModel.dart';
import '../../size_config.dart';
import '../ProductDescription/product_description_screen.dart';
import '../Search/search_screen.dart';
import '../SpecialPage/specialPage_screen.dart';
import './cart_state.dart';
import './cart_event.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CartActivity extends StatefulWidget {
  static const ROUTE_NAME = 'CartScreen';
  var callback;
  bool? pdp;
  CartActivity({this.callback, this.pdp});
  @override
  _CartActivityState createState() => _CartActivityState();
}

class _CartActivityState extends State<CartActivity> {
  late CartBloc cartBloc = CartBloc(SearchCartInitState());
  ShowCartModel? showCartModel = ShowCartModel();
  ShippingChargesModel? shippingChargesModel = ShippingChargesModel();
  CommonBannerModel? commonBannerModel = CommonBannerModel();
  CustomerDetail? customerDetail = CustomerDetail();
  var callBackFunction;
  late SharedPreferences userData;
  var mobile;
  var email;
  var token;
  var cartViewPayload = Map<String, dynamic>();
  var cartItemsPayload = <Map>[];
  var checkOutPayload;
  int promoDiscount = 0;
  String promocode = "";
  String promoName = "";
  String promoType = "";
  double orderTotal = 0.0;
  double totalSavings = 0.0;
  int countOfItemsWithLowInventory = 0;
  final TextEditingController guest_controller = new TextEditingController();
  List<Message>? msg;
  bool lowInventory = false;
  final _guestKey = GlobalKey<FormState>();
  DataRepo dataRepo = DataRepo.getInstance();

  @override
  void initState() {
    getInitState();
    super.initState();
  }

  getInitState() async {
    cartBloc.add(LoadCartEvent());
    initSharedPref();
  }

  getShippingCharges(String cart_value) async{
    cartBloc.add(LoadDeliveryEvent(cart_value));
  }

  void showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text('${msg}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future initSharedPref() async {
    await PreferencesManager.init();
    userData = await SharedPreferences.getInstance();
    mobile = (userData.getString('mobile') ?? '');
    email = (userData.getString('email') ?? '');
    token = (userData.getString('token') ?? '');
  }



  checkOutTrack() async{
    NetcoreEvents.checkOutTrack(
        showCartModel!.data!.cartItemSummary!.totalRegularPrice!,
        showCartModel!.data!.cartItemSummary!.totalplatformDiscount!,
        showCartModel!.data!.cartItemSummary!.shippingCharge!,
        orderTotal == 0.0
            ? showCartModel!.data!.cartItemSummary!.orderTotal!
            : orderTotal);
    AppsFlyer.checkOutTrack(
        showCartModel!.data!.cartItemSummary!.totalRegularPrice!,
        showCartModel!.data!.cartItemSummary!.totalplatformDiscount!,
        showCartModel!.data!.cartItemSummary!.shippingCharge!,
        orderTotal == 0.0
            ? showCartModel!.data!.cartItemSummary!.orderTotal!
            : orderTotal);
  }

  getCommonBannerInitState() async{
    cartBloc.add(BannerEvent());
  }


  Future<void> _launchInWebView(String url) async {
    if (await canLaunch('$url')) {
      await launch(
        '$url',
        forceWebView: true,
        forceSafariVC: true,
        //enableJavaScript: true,
        // headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch url';
    }
  }




  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return BlocProvider(
      create: (context) => cartBloc,
      child: BaseBlocListener(
          bloc: cartBloc,
          listener: (context, state) {
            if (state is CompletedCartState) {
              lowInventory = false;
              countOfItemsWithLowInventory = 0;
              showCartModel = state.showCartModel;
              getShippingCharges(showCartModel!.data!.cartItemSummary!.totalRetailPrice!.round().toString());
              getCommonBannerInitState();
              if (showCartModel!.data != null) {
                log("${showCartModel}");
                msg = null;
                promoDiscount = 0;
                promocode = "";
                promoName = "";
                promoType = "";
                orderTotal = 0.0;
                totalSavings = 0.0;
                if (showCartModel!
                    .data!.cartItemSummary!.totalplatformDiscount !=
                    0.0) {
                  totalSavings = showCartModel!
                      .data!.cartItemSummary!.totalplatformDiscount!;
                }
                for(var element in showCartModel!.data!
                    .showShoppingCartData!){
                  if (element.messageDetail !=
                      null) {
                    if (element.messageDetail!
                        .msgType ==
                        "LOW_INVENTORY" || element.messageDetail!
                        .msgType ==
                        "OUT_OF_STOCK") {
                        lowInventory = true;
                        countOfItemsWithLowInventory++;
                    }
                  }
                }
                NetcoreEvents.cartViewTrack(showCartModel!.data!.showShoppingCartData!,
                    showCartModel!.data!.cartItemSummary!.totalRegularPrice!,
                    showCartModel!.data!.cartItemSummary!.totalplatformDiscount!,
                    showCartModel!.data!.cartItemSummary!.shippingCharge!,
                    totalSavings,
                    orderTotal);
                AppsFlyer.cartViewTrack(showCartModel!.data!.showShoppingCartData!,
                    showCartModel!.data!.cartItemSummary!.totalRegularPrice!,
                    showCartModel!.data!.cartItemSummary!.totalplatformDiscount!,
                    showCartModel!.data!.cartItemSummary!.shippingCharge!,
                    totalSavings,
                    orderTotal);
              }
            }

            if(state is CompletedDeliverState){
              shippingChargesModel = state.shippingChargesModel;
            }

            if (state is GuestState) {
              if (state.profileUpdateModel!.message!.first.msgType !=
                  'INFO') {
                final snackBar = SnackBar(
                  backgroundColor: Color(0xffcd3a62),
                  duration: Duration(seconds: 3),
                  content: Text(
                    '${state.profileUpdateModel!.message![0].msgText!}',
                    style: TextStyle(color: Colors.white),
                  ),
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.white,
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                if (guest_controller.text.toString().length == 10) {
                  userData.setString(
                      'mobile', guest_controller.text.toString().trim());
                } else {
                  userData.setString(
                      'email', guest_controller.text.toString().trim());
                  customerDetail!.email = guest_controller.text.toString();
                  AppsFlyer.emailAdded();
                  NetcoreEvents.emailAdded();
                }

                getInitState();
                guest_controller.clear();
              }
            }

            if(state is IsEmailState){
              if(state.isEmailExistModel!.data != null){
                if(mobile != state.isEmailExistModel!.data!.mobile){
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xffcd3a62),
                    duration: Duration(seconds: 5),
                    content: Text(
                      'This Email is registered with other number',
                      style: TextStyle(color: Colors.black),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      textColor: Colors.white,
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else{
                  saveInitState(mobile.toString(),
                      guest_controller.text.toString().trim());
                }
              }
              else{
                saveInitState(mobile.toString(),
                    guest_controller.text.toString().trim());
              }
            }

            if(state is BannerState){
              commonBannerModel = state.commonBannerModel;
            }

            if (state is ErrorCartState) {
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
              bloc: cartBloc,
              condition: (oldState, currentState) {
                return !(BaseBlocBuilder.isBaseState(currentState));
              },
              builder: (BuildContext context, BaseState state) {
                if (showCartModel!.data != null) {
                  return Scaffold(
                      backgroundColor: Colors.white,
                      persistentFooterButtons: [
                        if(showCartModel!.data!.cartItemSummary!.shippingCharge! > 0 && shippingChargesModel!.message != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, right: 50, left: 50),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Add items worth ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 1.9 *
                                        SizeConfig.textMultiplier,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '₹${shippingChargesModel!.message![0].msgText}',
                                      style: TextStyle(
                                        color: Color(0xffcd3a62),
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 1.9 *
                                            SizeConfig.textMultiplier,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' for Free Shipping.',
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        InkWell(
                          onTap: (){
                            CustomerDetail? customerDetail =
                            dataRepo.userRepo
                                .getSavedUser();
                            if (customerDetail == null) {
                              Navigator.pushNamed(context,
                                  LoginScreen.ROUTE_NAME,
                                  arguments: {
                                    "cart" : true,
                                    "callback":
                                        (value) async {
                                      // if(value != null){
                                      //   await getInitState();
                                      // }
                                    }
                                  }).then((value) async {
                                widget.callback(true);
                                // cartBloc = CartBloc(SearchCartInitState());
                                cartBloc
                                    .add(LoadCartEvent());

                                await initSharedPref();
                                if (token
                                    .toString()
                                    .isNotEmpty) {
                                  if (mobile
                                      .toString()
                                      .isEmpty) {
                                    _enterGuest(
                                        context, 10);
                                  } else if (email
                                      .toString()
                                      .isEmpty) {
                                    _enterGuest(context, 0);
                                  }
                                }
                              });
                            } else {
                              if (!lowInventory) {
                                if (token
                                    .toString()
                                    .isNotEmpty) {
                                  if (mobile
                                      .toString()
                                      .isEmpty) {
                                    _enterGuest(
                                        context, 10);
                                  } else if (email
                                      .toString()
                                      .isEmpty || !email.contains(RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                                    _enterGuest(context, 0);
                                  } else {
                                    checkOutTrack();
                                    Navigator.pushNamed(
                                        context,
                                        CheckOutScreen
                                            .ROUTE_NAME,
                                        arguments: {
                                          "promocode":
                                          "${promocode}"
                                        });
                                  }
                                } else {
                                  checkOutTrack();
                                  Navigator.pushNamed(
                                      context,
                                      CheckOutScreen
                                          .ROUTE_NAME,
                                      arguments: {
                                        "promocode":
                                        "${promocode}"
                                      });
                                }
                              }
                              else {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.white,
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    countOfItemsWithLowInventory == showCartModel!.data!.showShoppingCartData!.length ?
                                        'All items are out of stock.\nPlease change quantity or remove item(s) to checkout.' :
                                    '$countOfItemsWithLowInventory/${showCartModel!.data!.showShoppingCartData!.length} items are out of stock.\nPlease change quantity or remove item(s) to checkout.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xffcd3a62),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            width: SizeConfig.screenWidth,
                            color: lowInventory ? Colors.pink[200] : Color(0xffcd3a62),
                            child: Center(
                              child: Text(
                                "PROCEED TO CHECKOUT",
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                      body: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            leading: widget.pdp ?? false
                                ? IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ))
                                : Container(
                              height: 0,
                            ),
                            actions: [
                              widget.pdp ?? false
                                  ? InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      WishListScreen.ROUTE_NAME,
                                      arguments: {
                                        "callback": (value) {
                                          if (value) {
                                          }
                                        },
                                      }).then((value) => getInitState());
                                },
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig
                                            .widthMultiplier),
                                    child: SvgPicture.asset(
                                        'assets/icons/wishlist.svg',
                                        height: 25,
                                        width: 25
                                    )),
                              )
                                  : Container(
                                height: 0,
                              ),
                            ],
                            backgroundColor: Colors.white,
                            shadowColor: const Color(0xffffd2d2),
                            pinned: true,
                            centerTitle: true,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                "Cart",
                                style: TextStyle(
                                    fontFamily: 'RecklessNeue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          if (msg != null)
                            SliverToBoxAdapter(
                              child: MessageScreen(msg == null
                                  ? showCartModel!.message!
                                  : msg),
                            ),
                          // if(commonBannerModel!.data != null && commonBannerModel!.data!.imageMobile != null)
                          //   SliverToBoxAdapter(
                          //     child: GestureDetector(
                          //       onTap: () {
                          //         if (commonBannerModel!.data!.type == "PLP") {
                          //           Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                          //             "query": "",
                          //             "id": "${commonBannerModel!.data!.action}",
                          //             "collection": false,
                          //             //"callback": widget.callback
                          //           });
                          //         } else if (commonBannerModel!.data!.type == "COLLECTION") {
                          //           Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                          //             "query": "",
                          //             "id": "${commonBannerModel!.data!.action}",
                          //             "collection": true,
                          //             //"callback": widget.callback
                          //           });
                          //         } else if(commonBannerModel!.data!.type ==
                          //             "PDP"){
                          //           Navigator.pushNamed(
                          //             context,
                          //             ProductDescriptionScreen.ROUTE_NAME,
                          //             arguments: {
                          //               "pid": '${commonBannerModel!.data!.action}',
                          //               "callback": (value) {
                          //                 if (value) {
                          //                   //widget.callback!(true);
                          //                 }
                          //               },
                          //             },
                          //           );
                          //         }else if (commonBannerModel!.data!.type == "URL") {
                          //           if(commonBannerModel!.data!.action! == "#"){
                          //             null;
                          //           }
                          //           else{
                          //             _launchInWebView(commonBannerModel!.data!.action!);
                          //           }
                          //         } else if (commonBannerModel!.data!.type == "SP") {
                          //           Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                          //               arguments: {"id": "${commonBannerModel!.data!.action}",
                          //                 //"callback": widget.callback
                          //               }).then((value) {
                          //             // widget.callback!(true);
                          //           });
                          //         }
                          //         AppsFlyer.bannerClick(
                          //                   commonBannerModel!.data!.mobileBannerId!,
                          //                   "CART",
                          //                   commonBannerModel!.data!.action!,
                          //                   commonBannerModel!.data!.type!,
                          //                   "0");
                          //               NetcoreEvents.bannerClick(
                          //                   commonBannerModel!.data!.mobileBannerId!,
                          //                   "CART",
                          //                   commonBannerModel!.data!.action!,
                          //                   commonBannerModel!.data!.type!,
                          //                   "0");
                          //       },
                          //       child: Container(
                          //         width: SizeConfig.screenWidth,
                          //         child: CachedNetworkImage(
                          //           fit: BoxFit.scaleDown,
                          //           imageUrl: '${commonBannerModel!.data!.imageMobile}',
                          //           placeholder: (context, url) => Image.network(
                          //             '${commonBannerModel!.data!.imageMobile}?w=${SizeConfig.screenWidth / 8}',
                          //             fit: BoxFit.fitWidth,
                          //             cacheWidth: 10,
                          //           ),
                          //           errorWidget: (context, url, error) => Container(),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          SliverToBoxAdapter(
                            child: Card(
                              elevation: 2,
                              shadowColor: Colors.black,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    msg = null;
                                    promoDiscount = 0;
                                    promoType = "";
                                    promocode = "";
                                    promoName = "";
                                    orderTotal = showCartModel!
                                        .data!.cartItemSummary!.orderTotal!;
                                    totalSavings = showCartModel!
                                        .data!
                                        .cartItemSummary!
                                        .totalplatformDiscount!;
                                  });
                                  Navigator.pushNamed(
                                      context, PromoScreen.ROUTE_NAME,
                                      arguments: {
                                        "cart_items": showCartModel!
                                            .data!.showShoppingCartData,
                                        "cart_value": showCartModel!.data!
                                            .cartItemSummary!.totalRetailPrice,
                                        "callback": (data, message, coupon,
                                            couponName, type) {
                                          if (data != null && data != 0.0) {
                                            setState(() {
                                              promoType = type;
                                              if(type == 'FREESHIPPING'){
                                                promoDiscount = 0;
                                                orderTotal = showCartModel!
                                                    .data!
                                                    .cartItemSummary!
                                                    .orderTotal! -
                                                    showCartModel!
                                                        .data!
                                                        .cartItemSummary!.shippingCharge!;
                                                totalSavings = showCartModel!
                                                    .data!
                                                    .cartItemSummary!.shippingCharge! +
                                                    showCartModel!
                                                        .data!
                                                        .cartItemSummary!
                                                        .totalplatformDiscount!;
                                                msg = message;
                                              }
                                              else{
                                                promoDiscount = data;
                                                orderTotal = showCartModel!
                                                    .data!
                                                    .cartItemSummary!
                                                    .orderTotal! -
                                                    data;
                                                totalSavings = data +
                                                    showCartModel!
                                                        .data!
                                                        .cartItemSummary!
                                                        .totalplatformDiscount;
                                                msg = message;
                                              }
                                              promocode = coupon;
                                              promoName = couponName;
                                            });
                                          } else {
                                            setState(() {
                                              msg = message;
                                            });
                                          }
                                        },
                                      });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4 *
                                            SizeConfig.heightMultiplier))),
                                leading: SvgPicture.asset(
                                  'assets/icons/promo.svg',
                                  height: 24,
                                  width: 24,
                                ),
                                title: Text(
                                  promoDiscount == 0
                                      ? "Available Offers"
                                      : "${promocode} Applied",
                                  style: TextStyle(
                                    fontFamily: 'RecklessNeue',
                                    color: Colors.black,
                                    fontSize: textScale >1 ? 2*SizeConfig.textMultiplier : 2.4*SizeConfig.textMultiplier,
                                  ),
                                ),
                                trailing: promoDiscount == 0
                                    ? Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                )
                                    : Text(
                                  "Change",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(0xffcd3a62),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return CartItem(
                                    showShoppingCartData: showCartModel!
                                        .data!.showShoppingCartData![index],
                                    callback: (value) {
                                      if (value != null) {
                                        if (value) {
                                          getInitState();
                                          widget.callback(true);
                                          Future.delayed(
                                              Duration(milliseconds: 500), () {
                                            widget.callback(true);
                                          });
                                        } else {}
                                      } else {}
                                    },
                                  );
                                }, childCount: showCartModel!.data!.totalItem!),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ShowOrderSummary(
                                    subtotal: showCartModel!.data!.cartItemSummary!.totalRegularPrice,
                                    platformDiscount: showCartModel!.data!.cartItemSummary!.totalplatformDiscount!,
                                    promoDiscount: promoDiscount.toDouble(),
                                    promoCode: promocode,
                                    credits: 0.0,
                                    creditsType: "Credits",
                                    deliveryCharges: promoType == 'FREESHIPPING' ? 0.0 :
                                    showCartModel!.data!.cartItemSummary!.shippingCharge,
                                    shippingMessage: null,
                                    totalSavings: totalSavings,
                                    orderTotal: orderTotal == 0.0
                                        ? showCartModel!.data!.cartItemSummary!.orderTotal
                                        : orderTotal,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  );
                }
                else {
                  return Scaffold(
                    appBar: AppBar(
                      leading: widget.pdp ?? false
                          ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ))
                          : Container(
                        height: 0,
                      ),
                      backgroundColor: Colors.white,
                      shadowColor: const Color(0xffffd2d2),
                      centerTitle: true,
                      title: Text(
                        "Cart",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 2 * SizeConfig.textMultiplier,
                            color: Colors.black),
                      ),
                    ),
                    body: Column(
                      children: [
                        Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: CachedNetworkImage(
                                        width: 200,
                                        height: 200,
                                        // fit: BoxFit.fitWidth,
                                        imageUrl:
                                        "https://taggd.gumlet.io/logo/cart-empty-icon.png",
                                        placeholder: (context, url) =>
                                            Center(
                                                child:
                                                CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Color(0xffcd3a62)),
                                                )),
                                        errorWidget:
                                            (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  if (widget.pdp ?? false)
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            SplashActivity.ROUTE_NAME,
                                                (r) => false);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: SizeConfig.screenWidth,
                                        color: Color(0xffcd3a62),
                                        child: Center(
                                          child: Text(
                                            "CONTINUE SHOPPING",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  );
                }

              }
          )),
    );
  }


  saveInitState(String mob, String mail) async {
    cartBloc.add(GuestEvent(mob, mail));
  }

  emailCheckState(String mail) async {
    cartBloc.add(IsEmailEvent(mail));
  }

  Future _enterGuest(BuildContext context, int type) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/addEmail.svg',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Add Your Email',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'RecklessNeue',
                      fontSize: 26
                    ),
                  ),
                  Text(
                    'Your email is not associated with Taggd account.\nStay updated with orders, promotions and more.',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        fontSize: 13.33
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _guestKey,
                      child: TextFormField(
                        validator:  (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your email in the format: name@example.com';
                          } else if (!value.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                            return 'Enter your email in the format: name@example.com';
                          }
                          return null;
                        },
                        controller: guest_controller,
                        cursorColor: Color(0xffcd3a62),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            labelText: "Email"),
                        keyboardType: type == 10
                            ? TextInputType.number
                            : TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff0A0A0A)),
                        fixedSize: MaterialStateProperty.all(Size(SizeConfig.screenWidth, 50)),
                      ),
                      onPressed: () {
                        if (_guestKey.currentState!.validate()) {
                            emailCheckState(guest_controller.text.toString().trim());
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                          'Save & Continue',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}