import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/orderConfirmationModel.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/OrderConfirmItem/orderConfirmItem_screen.dart';
import 'package:ouat/widgets/order_summary.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/commonBannerModel.dart';
import '../../size_config.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import '../ProductDescription/product_description_screen.dart';
import '../Search/search_screen.dart';
import '../SpecialPage/specialPage_screen.dart';
import './order_confirmation_state.dart';
import './order_confirmation_event.dart';
import './order_confirmation_bloc.dart';

class OrderConfirmationScreen extends StatefulWidget {
  static const String ROUTE_NAME = "OrderConfirmationScreen";
  int? order_id;
  OrderConfirmationScreen({
    this.order_id
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  late OrderConfirmationBloc orderConfirmationBloc = OrderConfirmationBloc(SearchInitState());
  OrderConfirmationModel? orderConfirmationModel = OrderConfirmationModel();
  CommonBannerModel? commonBannerModel = CommonBannerModel();
  var selectedIndex;
  var callBackFunction;



  @override
  void initState() {
    // categoryBloc = BlocProvider.of<CategoryBloc>(context);
    getOrderConfirmationInitState();
    selectedIndex = 0;
    super.initState();
  }


  getOrderConfirmationInitState() async {
    orderConfirmationBloc.add(LoadEvent(widget.order_id!));
  }

  getCommonBannerInitState() async{
    orderConfirmationBloc.add(BannerEvent());
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


  Future<bool> _onWillPop() {
     Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
    // if (Navigator.canPop(context)) {
    //   Navigator.of(context).pop();
    // } else {
    //   Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
    // }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
       onWillPop: _onWillPop,
      child: Scaffold(
          body: Container(
              padding:
              EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: BlocProvider(
                create: (context) => orderConfirmationBloc,
                child: BaseBlocListener(
                    bloc: orderConfirmationBloc,
                    listener: (context, state) {
    
                      if (state is CompletedState) {
                        orderConfirmationModel = state.orderConfirmationModel;
                        getCommonBannerInitState();
                        NetcoreEvents.productPurchaseTrack(orderConfirmationModel!.data!.orderItem,
                            orderConfirmationModel!.data!.priceSummary!.promoDiscount!,
                            orderConfirmationModel!.data!.priceSummary!.platformDiscount!,
                            orderConfirmationModel!.data!.priceSummary!.shippingCharge!,
                            orderConfirmationModel!.data!.priceSummary!.oderTotal!);
                        AppsFlyer.productPurchaseTrack(orderConfirmationModel!.data!.orderItem,
                            orderConfirmationModel!.data!.priceSummary!.promoDiscount!,
                            orderConfirmationModel!.data!.priceSummary!.platformDiscount!,
                            orderConfirmationModel!.data!.priceSummary!.shippingCharge!,
                            orderConfirmationModel!.data!.priceSummary!.oderTotal!);
                      }

                      if(state is BannerState){
                        commonBannerModel = state.commonBannerModel;
                      }
                      
                      else if(state is ErrorState){
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
                        bloc: orderConfirmationBloc,
                        condition: (oldState, currentState) {
                          return !(BaseBlocBuilder.isBaseState(currentState));
                        },
                        builder: (BuildContext context, BaseState state) {
    
                          if (orderConfirmationModel!.data != null) {
                            return Scaffold(
                              body: CustomScrollView(
                                slivers: [
                                  SliverAppBar(
                                    automaticallyImplyLeading: false,
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xffcd3a62),
                                    expandedHeight: 20 * SizeConfig.heightMultiplier,
                                    pinned: true,
                                    flexibleSpace: FlexibleSpaceBar(
                                      collapseMode: CollapseMode.pin,
                                      //titlePadding: EdgeInsets.only(right: 20),
                                      background: Container(
                                        width: double.maxFinite,
                                        // margin: EdgeInsets.symmetric(horizontal: 20),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.scaleDown,
                                          imageUrl: "${
                                              orderConfirmationModel!.data!.bannerImage
                                          }",
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                                valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                                              )),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if(commonBannerModel!.data != null && commonBannerModel!.data!.imageMobile != null)
                                    SliverToBoxAdapter(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (commonBannerModel!.data!.type == "PLP") {
                                            Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                                              "query": "",
                                              "id": "${commonBannerModel!.data!.action}",
                                              "collection": false,
                                              //"callback": widget.callback
                                            });
                                          } else if (commonBannerModel!.data!.type == "COLLECTION") {
                                            Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                                              "query": "",
                                              "id": "${commonBannerModel!.data!.action}",
                                              "collection": true,
                                              //"callback": widget.callback
                                            });
                                          } else if(commonBannerModel!.data!.type ==
                                              "PDP"){
                                            Navigator.pushNamed(
                                              context,
                                              ProductDescriptionScreen.ROUTE_NAME,
                                              arguments: {
                                                "pid": '${commonBannerModel!.data!.action}',
                                                "callback": (value) {
                                                  if (value) {
                                                    //widget.callback!(true);
                                                  }
                                                },
                                              },
                                            );
                                          }else if (commonBannerModel!.data!.type == "URL") {
                                            if(commonBannerModel!.data!.action! == "#"){
                                              null;
                                            }
                                            else{
                                              _launchInWebView(commonBannerModel!.data!.action!);
                                            }
                                          } else if (commonBannerModel!.data!.type == "SP") {
                                            Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                                                arguments: {"id": "${commonBannerModel!.data!.action}",
                                                  //"callback": widget.callback
                                                }).then((value) {
                                              // widget.callback!(true);
                                            });
                                          }
                                          AppsFlyer.bannerClick(
                                            commonBannerModel!.data!.mobileBannerId!,
                                            "CONFIRM",
                                            commonBannerModel!.data!.action!,
                                            commonBannerModel!.data!.type!,
                                            "0");
                                        NetcoreEvents.bannerClick(
                                            commonBannerModel!.data!.mobileBannerId!,
                                            "CONFIRM",
                                            commonBannerModel!.data!.action!,
                                            commonBannerModel!.data!.type!,
                                            "0");
                                        },
                                        child: Container(
                                          width: SizeConfig.screenWidth,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.scaleDown,
                                            imageUrl: '${commonBannerModel!.data!.imageMobile}',
                                            placeholder: (context, url) => Image.network(
                                              '${commonBannerModel!.data!.imageMobile}?w=${SizeConfig.screenWidth / 8}',
                                              fit: BoxFit.fitWidth,
                                              cacheWidth: 10,
                                            ),
                                            errorWidget: (context, url, error) => Container(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Confirm',
                                          style: TextStyle(
                                              fontFamily: 'RecklessNeue',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2*SizeConfig.textMultiplier,
                                              color: Colors.black
                                          ),
                                        ),
                                        Text(
                                            'Order No. ${orderConfirmationModel!.data!.customOrderNumber}',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 1.5*SizeConfig.textMultiplier,
                                              color: Colors.black
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                            (context , index){
                                          return
                                            OrderConfirmItemScreen(orderConfirmationModel!.data!.orderItem![index]);
                                        },
                                        childCount: orderConfirmationModel!.data!.orderItem!.length
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Delivery Address',
                                                style: TextStyle(
                                                    fontFamily: 'RecklessNeue',
                                                    color: Colors.black,
                                                    fontSize: 2.5*SizeConfig.textMultiplier,
                                                    fontWeight: FontWeight.bold
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${orderConfirmationModel!.data!.shippingAddress!.fullName}',
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: Colors.black,
                                                        fontSize: 2*SizeConfig.textMultiplier,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: '${orderConfirmationModel!.data!.shippingAddress!.address}\n',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      if(orderConfirmationModel!.data!.shippingAddress!.landmark != "")
                                                      TextSpan(
                                                        text: '${orderConfirmationModel!.data!.shippingAddress!.landmark}\n',
                                                      ),
                                                      TextSpan(
                                                        text: '${orderConfirmationModel!.data!.shippingAddress!.city}, ',
                                                      ),
                                                      TextSpan(
                                                        text: '${orderConfirmationModel!.data!.shippingAddress!.state}, ',
                                                      ),
                                                      TextSpan(
                                                        text: '${orderConfirmationModel!.data!.shippingAddress!.pincode}\n',
                                                      ),
                                                      TextSpan(
                                                        text: '${orderConfirmationModel!.data!.shippingAddress!.mobile} ',
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ShowOrderSummary(
                                                subtotal: orderConfirmationModel!.data!.priceSummary!.oderTotal,
                                                platformDiscount: orderConfirmationModel!.data!.priceSummary!.platformDiscount,
                                                promoDiscount: orderConfirmationModel!.data!.priceSummary!.promoDiscount,
                                                promoCode: orderConfirmationModel!.data!.priceSummary!.promocode,
                                                credits: orderConfirmationModel!.data!.priceSummary!.creditApplied,
                                                creditsType: "Credits Applied",
                                                deliveryCharges: orderConfirmationModel!.data!.priceSummary!.shippingCharge,
                                                shippingMessage: null,
                                                totalSavings: 0.0,
                                                orderTotal: orderConfirmationModel!.data!.priceSummary!.orderPayable,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: SizeConfig.screenWidth,
                                        color: Color(0xffcd3a62),
                                        child: Center(
                                          child: Text(
                                            "CONTINUE SHOPPING",
                                            style:
                                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        })),
              ))
      ),
    );
  }
}
