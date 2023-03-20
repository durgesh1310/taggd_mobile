import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/commonBannerModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/recommendationModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/screens/Cart/cart_screen.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/ProductDescription/available_size_information.dart';
import 'package:ouat/screens/ProductDescription/offers.dart';
import 'package:ouat/screens/ProductDescription/pdp_shimmer.dart';
import 'package:ouat/screens/ProductDescription/product_information.dart';
import 'package:ouat/screens/ProductDescription/recommendations.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/badge.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/widgets/general_dialog.dart';
import '../Search/search_screen.dart';
import '../SpecialPage/specialPage_screen.dart';
import './product_description_event.dart';
import './product_description_state.dart';
import './product_description_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductDescriptionScreen extends StatefulWidget {
  static const String ROUTE_NAME = "ProductDescriptionScreen";
  String pid;
  final ValueChanged<bool>? callback;
  ProductDescriptionScreen({required this.pid, this.callback});

  @override
  _ProductDescriptionScreenState createState() =>
      _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen>
    with SingleTickerProviderStateMixin {
  int _current = 0, size_index = -1;
  ScrollController controller = ScrollController();
  bool message = false;
  var _expandProd = false;
  var _expandDel = false;
  final CarouselController _controller = CarouselController();
  late ProductDescriptionBloc productDescriptionBloc =
      ProductDescriptionBloc(SearchInitState());
  bool isLeftCollapsed = true;
  bool isRightCollapsed = true;
  bool isTopCollapsed = true;
  bool isBottomCollapsed = true;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _animationController;
  final TextEditingController pincode_controller = new TextEditingController();
  ProductDescriptionModel? productDescriptionModel = ProductDescriptionModel();
  RecommendationModel? recommendationModel = RecommendationModel();
  OrderStatusModel? orderStatusModel = OrderStatusModel();
  CommonBannerModel? commonBannerModel = CommonBannerModel();
  late SharedPreferences userData;
  String pin = '';
  var callBackFunction;
  String serviceable = "";
  final _pinKey = GlobalKey<FormState>();
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  DateTime now = DateTime.now();
  int? count = 0;
  var payload,
      sizePayload,
      addToCartPayload,
      addToWishlistPayload,
      removeFromWishlistPayload;

  @override
  void initState() {
    super.initState();
    print(now.microsecond.toString());
    getInitState();
    _animationController = AnimationController(vsync: this, duration: duration);
  }

  getInitState() async {
    productDescriptionBloc.add(LoadEvent(widget.pid));
  }

  pincodeData() async{
    userData = await SharedPreferences.getInstance();
    pincode_controller.text = (userData.getString('pincode') ?? '');
    pin = (userData.getString('pincode') ?? '');
    serviceable = (userData.getString('seviceable') ?? '');
  }

  addToCartTrack(int value) async {
    NetcoreEvents.addToCartTrack(productDescriptionModel!.data!.category!,
        productDescriptionModel!.data!.subCategory!,
        productDescriptionModel!.data!.images![0],
        productDescriptionModel!.data!.productSubtype!,
        productDescriptionModel!.data!.productType!,
        productDescriptionModel!.data!.name!,
        productDescriptionModel!.data!.price!,
        productDescriptionModel!.data!.regularPrice!,
        productDescriptionModel!.data!.skuResponse![value].size!,
        productDescriptionModel!.data!.discount!);
    AppsFlyer.addToCartTrack(productDescriptionModel!.data!.category!,
        productDescriptionModel!.data!.subCategory!,
        productDescriptionModel!.data!.images![0],
        productDescriptionModel!.data!.productSubtype!,
        productDescriptionModel!.data!.productType!,
        productDescriptionModel!.data!.name!,
        productDescriptionModel!.data!.price!,
        productDescriptionModel!.data!.regularPrice!,
        productDescriptionModel!.data!.skuResponse![value].size!,
        productDescriptionModel!.data!.discount!);
  }

  itemSelectedTrack(int value) async {
    NetcoreEvents.itemSelectedTrack(productDescriptionModel!.data!.category!,
        productDescriptionModel!.data!.subCategory!,
        productDescriptionModel!.data!.images![0],
        productDescriptionModel!.data!.productSubtype!,
        productDescriptionModel!.data!.brand!,
        productDescriptionModel!.data!.productType!,
        productDescriptionModel!.data!.name!,
        productDescriptionModel!.data!.price!,
        productDescriptionModel!.data!.regularPrice!,
        productDescriptionModel!.data!.skuResponse![value].size!,
        productDescriptionModel!.data!.discount!);
    AppsFlyer.itemSelectedTrack(productDescriptionModel!.data!.category!,
        productDescriptionModel!.data!.subCategory!,
        productDescriptionModel!.data!.images![0],
        productDescriptionModel!.data!.productSubtype!,
        productDescriptionModel!.data!.brand!,
        productDescriptionModel!.data!.productType!,
        productDescriptionModel!.data!.name!,
        productDescriptionModel!.data!.price!,
        productDescriptionModel!.data!.regularPrice!,
        productDescriptionModel!.data!.skuResponse![value].size!,
        productDescriptionModel!.data!.discount!);
  }

  pincodeValidInitState(String pincode) async {
    productDescriptionBloc.add(LoadingEvent(pincode));
  }

  addToCartInitState(String sku, String quantity) async {
    //print(email_controller.toString());
    productDescriptionBloc.add(ProgressEvent(sku, quantity));
  }

  countCartItems() async {
    productDescriptionBloc.add(CountingEvent());
    widget.callback!(true);
  }

  getRecommendationInitState() async {
    productDescriptionBloc.add(RecommendingEvent(widget.pid));
  }
  
  getCommonBannerInitState() async{
    productDescriptionBloc.add(BannerEvent());
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
      create: (context) => productDescriptionBloc,
      child: BaseBlocListener(
        bloc: productDescriptionBloc,
        listener: (context, dynamic state) {
          if (state is CompletedState) {
            productDescriptionModel = state.productDescriptionModel;
            //precacheImage(NetworkImage('${productDescriptionModel!.data!.images![0]}?w=520'), context);
            countCartItems();
            pincodeData();
            getRecommendationInitState();
            getCommonBannerInitState();
            NetcoreEvents.productViewTrack(productDescriptionModel!.data!.category!,
                productDescriptionModel!.data!.subCategory!,
                productDescriptionModel!.data!.images![0],
                productDescriptionModel!.data!.productSubtype!,
                productDescriptionModel!.data!.brand!,
                productDescriptionModel!.data!.productType!,
                productDescriptionModel!.data!.name!,
                productDescriptionModel!.data!.price!,
                productDescriptionModel!.data!.regularPrice!,
                productDescriptionModel!.data!.discount!);
            AppsFlyer.productViewTrack(productDescriptionModel!.data!.category!,
                productDescriptionModel!.data!.subCategory!,
                productDescriptionModel!.data!.images![0],
                productDescriptionModel!.data!.productSubtype!,
                productDescriptionModel!.data!.brand!,
                productDescriptionModel!.data!.productType!,
                productDescriptionModel!.data!.name!,
                productDescriptionModel!.data!.price!,
                productDescriptionModel!.data!.regularPrice!,
                productDescriptionModel!.data!.discount!);
          }

          if (state is FavouriteState) {
            productDescriptionModel!.data!.isItemWishListed = true;
            NetcoreEvents.addToWishlistTrack(productDescriptionModel!.data!.category!,
                productDescriptionModel!.data!.subCategory!,
                productDescriptionModel!.data!.images![0],
                productDescriptionModel!.data!.productType!,
                productDescriptionModel!.data!.name!,
                productDescriptionModel!.data!.price!,
                productDescriptionModel!.data!.regularPrice!,
                size_index == -1
                    ? "No Size Selected"
                    : "${productDescriptionModel!.data!.skuResponse![size_index].size}",
                productDescriptionModel!.data!.discount!);
            AppsFlyer.addToWishlistTrack(productDescriptionModel!.data!.category!,
                productDescriptionModel!.data!.subCategory!,
                productDescriptionModel!.data!.images![0],
                productDescriptionModel!.data!.productType!,
                productDescriptionModel!.data!.name!,
                productDescriptionModel!.data!.price!,
                productDescriptionModel!.data!.regularPrice!,
                size_index == -1
                    ? "No Size Selected"
                    : "${productDescriptionModel!.data!.skuResponse![size_index].size}",
                productDescriptionModel!.data!.discount!);
            widget.callback!(false);
          }

          if (state is UnFavouriteState) {
            productDescriptionModel!.data!.isItemWishListed = false;
            NetcoreEvents.removeFromWishlistTrack(productDescriptionModel!.data!.productId!);
            AppsFlyer.removeFromWishlistTrack(productDescriptionModel!.data!.productId!);
            widget.callback!(false);
          }

          if (state is CompletedCheckState) {
            FocusScope.of(context).requestFocus(FocusNode());
            state.pincodeValidationModel!.message!.runtimeType != String
                ? serviceable =
                    state.pincodeValidationModel!.message![0].msgText!
                : serviceable = state.pincodeValidationModel!.message!;
            state.pincodeValidationModel!.message!.runtimeType != String
                ? userData.setString('seviceable',
                    state.pincodeValidationModel!.message![0].msgText!)
                : userData.setString(
                    'seviceable', state.pincodeValidationModel!.message!);

            pin = pincode_controller.text.toString();
          }

          if (state is CompletedAddingState) {
            if (state.addToCartModel!.message!.first.msgType == 'WARNING') {
              Fluttertoast.showToast(
                  msg: state.addToCartModel!.success == false
                      ? state.addToCartModel!.message![0].msgText!
                      : state.addToCartModel!.message![0].msgText!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xffcd3a62),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              countCartItems();
              controller.animateTo(
                  SizeConfig.screenHeight * 1.4,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.ease
              );
              widget.callback!(true);
            }
          }

          if (state is CountingState) {
            orderStatusModel = state.orderStatusModel;
            count = orderStatusModel!.data != null ? orderStatusModel!.data : 0;
            log("${state.orderStatusModel.toString()}");
          }

          if (state is RecommendingState) {
            recommendationModel = state.recommendationModel;
          }
          
          if(state is BannerState){
            commonBannerModel = state.commonBannerModel;
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
          bloc: productDescriptionBloc,
          condition: (oldState, currentState) {
            return !(BaseBlocBuilder.isBaseState(currentState));
          },
          builder: (context, state) {
            // return Container();
            if (productDescriptionModel!.data != null) {
              return SafeArea(
                child: Scaffold(
                  bottomNavigationBar: InkWell(
                    onTap: () {
                      if (productDescriptionModel!.data!.inventory!.inStock ==
                          true) {
                        if (size_index == -1 &&
                            productDescriptionModel!.data!.sizeChart!.length >
                                0) {
                          _enterSize(context);
                        } else if (productDescriptionModel!
                            .data!.sizeChart!.length <
                            1) {
                          addToCartInitState(
                              productDescriptionModel!
                                  .data!.skuResponse![0].sku!,
                              "1");
                          addToCartTrack(0);
                        } else if (productDescriptionModel!.data!
                                .skuResponse![size_index].inventoryCount ==
                            0) {
                          null;
                        } else {
                          addToCartInitState(
                              productDescriptionModel!
                                  .data!.skuResponse![size_index].sku!,
                              "1");
                          addToCartTrack(size_index);
                        }
                      } else {
                        null;
                      }
                    },
                    child: Container(
                      height: 50,
                      width: SizeConfig.screenWidth/2,
                      color:
                          productDescriptionModel!.data!.inventory!.inStock ==
                                  true
                              ? Color(0xffcd3a62)
                              : Colors.pink[200],
                      child: Center(
                        child: Text(
                          productDescriptionModel!.data!.inventory!.inStock ==
                                  true
                              ? "ADD TO CART"
                              : "OUT OF STOCK",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  body: CustomScrollView(
                    controller: controller,
                    slivers: [
                      SliverAppBar(
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              CustomerDetail? customerDetail =
                                  DataRepo.getInstance()
                                      .userRepo
                                      .getSavedUser();
                              if (customerDetail == null) {
                                Navigator.pushNamed(
                                    context, LoginScreen.ROUTE_NAME,
                                    arguments: {
                                      "callback": (value) {
                                        if (value != null) {
                                          // productDescriptionBloc.add(
                                          //     AddToFavouriteEvent(productDescriptionModel));
                                        }
                                      }
                                    }).then((value) {
                                  widget.callback!(true);
                                  productDescriptionBloc.add(
                                      AddToFavouriteEvent(
                                          productDescriptionModel));
                                });
                              } else {
                                productDescriptionBloc.add(AddToFavouriteEvent(
                                    productDescriptionModel));
                              }
                            },
                            icon: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18,
                              child: productDescriptionModel!
                                          .data!.isItemWishListed ??
                                      false
                                  ? SvgPicture.asset(
                                'assets/icons/wishlisted.svg',
                                height: 24,
                                width: 24,
                              )
                                  : SvgPicture.asset(
                                'assets/icons/addWishlist.svg',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ),
                          Badge(
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, CartActivity.ROUTE_NAME,
                                      arguments: {
                                        "callback": (value) {
                                          if (value) {
                                            countCartItems();
                                          }
                                        },
                                        "pdp": true
                                      });
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 18,
                                  child: SvgPicture.asset(
                                    'assets/icons/bag.svg',
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                              count == 0 ? "" : count.toString(),
                              Color(0xffcd3a62),
                              8,
                              8),
                        ],
                        backgroundColor: Colors.white,
                        expandedHeight: SizeConfig.screenWidth * 1.6,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Hero(
                            tag: widget.pid,
                            child: Column(children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: CarouselSlider.builder(
                                            carouselController: _controller,
                                            options: CarouselOptions(
                                              enlargeCenterPage: true,
                                              height:
                                                  SizeConfig.screenWidth * 1.6,
                                              viewportFraction: 1.0,
                                              onPageChanged: (index, reason) {
                                                if (index == 1) {
                                                  message = true;
                                                  isLeftCollapsed = false;
                                                  isTopCollapsed = false;
                                                } else {
                                                  message = false;
                                                }
                                                setState(() {
                                                  _current = index;
                                                });
                                              },
                                            ),
                                            itemCount: productDescriptionModel!
                                                .data!.images!.length,
                                            itemBuilder: (BuildContext context,
                                                int itemIndex,
                                                int pageViewIndex) {
                                              return Container(
                                                width: double.maxFinite,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  maxWidthDiskCache: 520,
                                                  imageUrl: '${productDescriptionModel!.data!.images![itemIndex]}?w=500' ?? "",
                                                  placeholder: (context, url) => Center(
                                                    child: CircularProgressIndicator(
                                                      color: Color(0xffcd3a62),
                                                      strokeWidth: 1.5,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    productDescriptionModel!
                                                .data!.msgOnImage!.length >
                                            0
                                        ? Positioned(
                                      bottom: 18,
                                      left: 5,
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                color: Color(0xfff2ebd3),
                                                child: Text(
                                                  '${productDescriptionModel!.data!.msgOnImage![0]}',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.black,
                                                      fontSize: 1.5 *
                                                          SizeConfig
                                                              .textMultiplier),
                                                )),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: productDescriptionModel!
                                      .data!.images!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: _current == entry.key ? 10.0 : 6,
                                        height: _current == entry.key ? 10.0 : 6,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? const Color(0xffC4C4C4)
                                                    : Color(0xff5F5F5F))
                                                .withOpacity(
                                                    _current == entry.key
                                                        ? 0.9
                                                        : 0.4)),
                                      ),
                                    );
                                  }).toList()),
                            ]),
                          ),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   '${productDescriptionModel!.data!.brand}',
                              //   style: TextStyle(
                              //       fontFamily: 'RecklessNeue',
                              //       color: Colors.black,
                              //       fontSize: textScale>1 ? 1.90 * SizeConfig.textMultiplier : 2.2 * SizeConfig.textMultiplier,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier,
                              ),
                              Text(
                                '${productDescriptionModel!.data!.name}',
                                style: TextStyle(
                                  fontFamily: 'RecklessNeue',
                                  color: Colors.black,
                                  fontSize: textScale>1 ? 2 * SizeConfig.textMultiplier : 2.3 * SizeConfig.textMultiplier,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: size_index == -1
                                        ? '₹${numberFormat.format(productDescriptionModel!.data!.price!.round())}\t'
                                        : '₹${numberFormat.format(productDescriptionModel!.data!.skuResponse![size_index].retailPrice!.round())}\t',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.black,
                                        fontSize:
                                            2.2 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      size_index != -1
                                          ? productDescriptionModel!
                                                      .data!
                                                      .skuResponse![size_index]
                                                      .retailPrice <
                                                  productDescriptionModel!
                                                      .data!
                                                      .skuResponse![size_index]
                                                      .regularPrice
                                              ? TextSpan(
                                                  text: (productDescriptionModel!.data!.skuResponse![size_index].regularPrice! <
                                                          productDescriptionModel!
                                                              .data!
                                                              .skuResponse![
                                                                  size_index]
                                                              .retailPrice!)
                                                      ? '₹${numberFormat.format(productDescriptionModel!.data!.skuResponse![size_index].regularPrice!.round())}\t'
                                                      : '₹${numberFormat.format(productDescriptionModel!.data!.regularPrice!.round())}\t',
                                                  style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Colors.grey,
                                                      fontSize: 1.75 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      decoration: TextDecoration
                                                          .lineThrough))
                                              : TextSpan(text: "")
                                          : TextSpan(
                                              text: productDescriptionModel!.data!.price <
                                                      productDescriptionModel!
                                                          .data!.regularPrice
                                                  ? '₹${numberFormat.format(productDescriptionModel!.data!.regularPrice!.round())}\t'
                                                  : '',
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Colors.grey,
                                                  fontSize: 1.75 *
                                                      SizeConfig.textMultiplier,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                      TextSpan(
                                          text: productDescriptionModel!
                                                      .data!.discount ==
                                                  null
                                              ? ''
                                              : '\t${productDescriptionModel!.data!.discount}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.green,
                                            fontSize: 1.75 *
                                                SizeConfig.textMultiplier,
                                          )),
                                    ]),
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier,
                              ),
                              if (size_index != -1)
                                productDescriptionModel!
                                                .data!
                                                .skuResponse![size_index]
                                                .inventoryCount! <=
                                            3 &&
                                        productDescriptionModel!
                                                .data!
                                                .skuResponse![size_index]
                                                .inventoryCount! >
                                            0
                                    ? SizedBox(
                                        child: DefaultTextStyle(
                                          style: const TextStyle(
                                            fontSize: 50.0,
                                          ),
                                          child: Container(
                                            width: SizeConfig.screenWidth / 2,
                                            child: Chip(
                                              backgroundColor: Colors.red[100],
                                              label: Text(
                                                  'Only ${productDescriptionModel!.data!.skuResponse![size_index].inventoryCount} Item Left',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.red,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 1.75 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                  )),
                                              avatar: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  "assets/image/Key_red.jpg",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              if (size_index != -1)
                                productDescriptionModel!
                                            .data!
                                            .skuResponse![size_index]
                                            .inventoryCount! ==
                                        0
                                    ? Container(
                                        width: SizeConfig.screenWidth / 2,
                                        child: Chip(
                                          backgroundColor: Colors.red[100],
                                          label: Text('OUT OF STOCK',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.red,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 1.75 *
                                                    SizeConfig.textMultiplier,
                                              )),
                                          avatar: CircleAvatar(
                                            backgroundImage: AssetImage(
                                              "assets/image/Key_red.jpg",
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              Text(
                                'Inclusive of all taxes',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    fontSize: 0.95 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 1.5 * SizeConfig.heightMultiplier,
                              ),
                              Divider(
                                color: const Color(0xfff9d8d8),
                                thickness: 1,
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier,
                              ),
                              productDescriptionModel!
                                  .data!.sizeChart!.length >
                                  0
                                  ? AvailableSize(
                                  productDescriptionModel!
                                      .data!.sizeChart![0],
                                  productDescriptionModel!
                                      .data!.skuResponse, (value) {
                                if (value != null) {
                                  setState(() {
                                    size_index = value;
                                  });
                                  itemSelectedTrack(value);
                                }
                              })
                                  : Container(),
                              SizedBox(
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              productDescriptionModel!.data!.offers!.length > 0
                                  ? Offers(
                                      productDescriptionModel!.data!.offers)
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    pin == ''
                                        ? 'Delivery Availability'
                                        : '$pin ${serviceable.substring(serviceable.indexOf(' '))}',
                                    style: TextStyle(
                                        fontFamily: 'RecklessNeue',
                                        fontSize: textScale>1 ? 1.7 * SizeConfig.textMultiplier : 2 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  InkWell(
                                    child: Text(
                                      'Check Pincode',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: textScale>1 ? 1.7 * SizeConfig.textMultiplier : 2 * SizeConfig.textMultiplier,
                                        color: Color(0xffcd3a62),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _expandDel = !_expandDel;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (_expandDel)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            height:
                                                7 * SizeConfig.heightMultiplier,
                                            child: Form(
                                              key: _pinKey,
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter your Pincode';
                                                  } else if (!RegExp(
                                                          "^[1-9]{1}[0-9]{2}\\s{0,1}[0-9]{3}\$")
                                                      .hasMatch("$value")) {
                                                    return 'Please enter Valid Pincode';
                                                  }
                                                  return null;
                                                },
                                                controller: pincode_controller,
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: Color(0xffcd3a62),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      6),
                                                ],
                                                decoration: InputDecoration(
                                                  hintText: 'Enter Pin Code',
                                                  contentPadding:
                                                      EdgeInsets.all(5),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xffcd3a62)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              // if(_formKey.currentState!.validate()){}
                                              if (_pinKey.currentState!
                                                  .validate()) {
                                                userData.setString(
                                                    'pincode',
                                                    pincode_controller.text
                                                        .toString());
                                                pincodeValidInitState(
                                                    pincode_controller.text
                                                        .toString());
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                setState(() {
                                                  _expandDel = !_expandDel;
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.black),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      SizeConfig.screenWidth /
                                                          16),
                                              child: Text(
                                                'Check',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(
                                height: 1.5 * SizeConfig.heightMultiplier,
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    productDescriptionModel!.data!.edd == null
                                        ? Container()
                                        : Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: SvgPicture.asset(
                                                  'assets/icons/delivery.svg',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              Text(
                                                'Get it by ${productDescriptionModel!.data!.edd}',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 1.5 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                    productDescriptionModel!.data!.isCod ==
                                            false
                                        ? Container()
                                        : Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: SvgPicture.asset(
                                                  'assets/icons/cod.svg',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              Text(
                                                'Cash on Delivery Available',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 1.5 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                    productDescriptionModel!
                                                .data!.isReturnable ==
                                            false
                                        ? Container()
                                        : Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: SvgPicture.asset(
                                                  'assets/icons/return.svg',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              Text(
                                                '7 days Return',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 1.5 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                    productDescriptionModel!
                                                .data!.isExchangeable ==
                                            false
                                        ? Container()
                                        : Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: SvgPicture.asset(
                                                  'assets/icons/exchange.svg',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                              Text(
                                                'Product is exchangeable',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 1.5 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: const Color(0xfff9d8d8),
                                thickness: 1,
                              ),
                              SizedBox(
                                height: SizeConfig.heightMultiplier,
                              ),
                              /* DeliveryInformation(
                                  edd: productDescriptionModel!.data!.edd,
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),*/
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  setState(() {
                                    _expandProd = !_expandProd;
                                  });
                                },
                                leading: Text(
                                  'Product Information',
                                  style: TextStyle(
                                      fontFamily: 'Fraunces',
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                trailing: Icon(_expandProd
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                              ),
                              if (_expandProd)
                                Container(
                                  child: ProductInformation(
                                      productDescription:
                                          productDescriptionModel!
                                              .data!.pdpDetailDescription),
                                ),
                              if(commonBannerModel!.data != null && commonBannerModel!.data!.imageMobile != null)
                                // GestureDetector(
                                //   onTap: () {
                                //     if (commonBannerModel!.data!.type == "PLP") {
                                //       Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                                //         "query": "",
                                //         "id": "${commonBannerModel!.data!.action}",
                                //         "collection": false,
                                //         "callback": widget.callback
                                //       });
                                //     } else if (commonBannerModel!.data!.type == "COLLECTION") {
                                //       Navigator.pushNamed(context, SearchScreen.ROUTE_NAME, arguments: {
                                //         "query": "",
                                //         "id": "${commonBannerModel!.data!.action}",
                                //         "collection": true,
                                //         "callback": widget.callback
                                //       });
                                //     } else if(commonBannerModel!.data!.type ==
                                //         "PDP"){
                                //       Navigator.pushNamed(
                                //         context,
                                //         ProductDescriptionScreen.ROUTE_NAME,
                                //         arguments: {
                                //           "pid": '${commonBannerModel!.data!.action}',
                                //           "callback": (value) {
                                //             if (value) {
                                //               widget.callback!(true);
                                //             }
                                //           },
                                //         },
                                //       );
                                //     }else if (commonBannerModel!.data!.type == "URL") {
                                //       if(commonBannerModel!.data!.action! == "#"){
                                //         null;
                                //       }
                                //       else{
                                //         _launchInWebView(commonBannerModel!.data!.action!);
                                //       }
                                //     } else if (commonBannerModel!.data!.type == "SP") {
                                //       Navigator.pushNamed(context, SpecialPage.ROUTE_NAME,
                                //           arguments: {"id": "${commonBannerModel!.data!.action}",
                                //             "callback": widget.callback}).then((value) {
                                //         // widget.callback!(true);
                                //       });
                                //     }
                                //     AppsFlyer.bannerClick(
                                //       commonBannerModel!.data!.mobileBannerId!,
                                //       "PDP",
                                //       commonBannerModel!.data!.action!,
                                //       commonBannerModel!.data!.type!,
                                //       "0");
                                //   NetcoreEvents.bannerClick(
                                //       commonBannerModel!.data!.mobileBannerId!,
                                //       "PDP",
                                //       commonBannerModel!.data!.action!,
                                //       commonBannerModel!.data!.type!,
                                //       "0");
                                //   },
                                //   child: Container(
                                //     width: SizeConfig.screenWidth,
                                //     child: CachedNetworkImage(
                                //       fit: BoxFit.scaleDown,
                                //       imageUrl: '${commonBannerModel!.data!.imageMobile}',
                                //       placeholder: (context, url) => Image.network(
                                //         '${commonBannerModel!.data!.imageMobile}?w=${SizeConfig.screenWidth / 8}',
                                //         fit: BoxFit.fitWidth,
                                //         cacheWidth: 10,
                                //       ),
                                //       errorWidget: (context, url, error) => Container(),
                                //     ),
                                //   ),
                                // ),
                              if (recommendationModel!.data != null)
                                Container(
                                    child: Recommendations(
                                  recommendationModel!,
                                  (val) {
                                    if (val) {
                                     countCartItems();
                                    }
                                  },
                                )),
                            ],
                          ),
                        )
                      ])),
                    ],
                  ),
                ),
              );
            } else {
              return Material(child: PdpShimmer());
            }
          },
        ),
      ),
    );
  }

  Future _enterSize(BuildContext ctx) async {
    await showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight / 5),
      context: ctx,
      builder: (_) {
        if (productDescriptionModel!.data!.sizeChart!.length < 1) {
          addToCartInitState(
              productDescriptionModel!.data!.skuResponse![0].sku!, "1");
          itemSelectedTrack(0);
          addToCartTrack(0);
          Navigator.pop(ctx, true);
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xffcd3a62),
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AvailableSize(productDescriptionModel!.data!.sizeChart![0],
                productDescriptionModel!.data!.skuResponse, (value) {
              if (value != null) {
                print(value);
                addToCartInitState(
                    productDescriptionModel!.data!.skuResponse![value].sku!,
                    "1");
                itemSelectedTrack(value);
                addToCartTrack(value);
                Navigator.pop(ctx, true);
              }
            }),
          );
        }
        ;
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }
}
