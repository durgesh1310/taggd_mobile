import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/searchModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:ouat/screens/Search/search_bloc.dart';
import 'package:ouat/screens/Search/search_state.dart';
import 'package:ouat/screens/Search/search_event.dart';
import 'package:ouat/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';


class ProductItem extends StatefulWidget {
  PlpCard plpCard;
  final ValueChanged<bool>? callback;
  ProductItem({required this.plpCard, this.callback});

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late SearchBloc searchBloc = SearchBloc(SearchInitState());
  var callBackFunction;
  var addToWishlistPayload;
  var removeFromWishlistPayload;
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');


  void preloadImages() {
    widget.plpCard.imageUrls!.forEach((element) {
      precacheImage(
          NetworkImage('${element}?w=520'),
          context
      );
    });
  }


  @override
  void didChangeDependencies() {
    precacheImage(
        NetworkImage('${widget.plpCard.imageUrls![0]}?w=345'),
        context
    );
    super.didChangeDependencies();
  }

  wishInitState(bool isWishlisted, int product_id) async {
    CustomerDetail? customerDetail =
        DataRepo.getInstance().userRepo.getSavedUser();
    if (customerDetail == null) {
      Navigator.pushNamed(context, LoginScreen.ROUTE_NAME, arguments: {
        "callback": (value) {
          if (value != null) {
          }
        }
      }).then((value) {
        searchBloc.add(WishlistingEvent(isWishlisted, product_id));
      });
    } else {
      searchBloc.add(WishlistingEvent(isWishlisted, product_id));
    }
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return BlocProvider(
      create: (context) => searchBloc,
      child: BaseBlocListener(
        bloc: searchBloc,
        listener: (context, state) {
          log(state.toString());

          if (state is WishlistingState) {
            NetcoreEvents.addToWishlistTrack("",
                "",
                widget.plpCard.imageUrls![0],
                "",
                widget.plpCard.name!,
                widget.plpCard.maxRetailPrice,
                widget.plpCard.maxRegularPrice,
                "No Size Selected",
                widget.plpCard.discount!);
            AppsFlyer.addToWishlistTrack("",
                "",
                widget.plpCard.imageUrls![0],
                "",
                widget.plpCard.name!,
                widget.plpCard.maxRetailPrice,
                widget.plpCard.maxRegularPrice,
                "No Size Selected",
                widget.plpCard.discount!);
            widget.plpCard.isWishlisted = true;
          }
          if (state is UnFavouriteState) {
            NetcoreEvents.removeFromWishlistTrack(widget.plpCard.productId!);
            AppsFlyer.removeFromWishlistTrack(widget.plpCard.productId!);
            widget.plpCard.isWishlisted = false;
          }

          if (state is ErrorState) {
            GeneralDialog.show(
              context,
              title: 'Error',
              message: state.message,
              closeOnAction: true,
              positiveButtonLabel: 'OK',
              onPositiveTap: () {},
            );
          }
        },
        child: BaseBlocBuilder(
          bloc: searchBloc,
          condition: (oldState, currentState) {
            return !(BaseBlocBuilder.isBaseState(currentState));
          },
          builder: (BuildContext context, BaseState state) {
            return GestureDetector(
              onTap: () {
                preloadImages();
                Navigator.pushNamed(
                  context,
                  ProductDescriptionScreen.ROUTE_NAME,
                  arguments: {
                    "pid": '${widget.plpCard.productId}',
                    "callback": (value) {
                      if (value) {
                        widget.callback!(true);
                      } else {
                        if (widget.plpCard.isWishlisted == true) {
                          setState(() {
                            widget.plpCard.isWishlisted = false;
                          });
                        } else {
                          setState(() {
                            widget.plpCard.isWishlisted = true;
                          });
                        }
                      }
                    },
                  },
                );
              },
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          widget.plpCard.imageUrls == null ||
                              widget.plpCard.imageUrls!.length == 0
                              ? FadeInImage(
                            height: SizeConfig.screenHeight/2,
                            placeholder:
                            AssetImage('assets/image/white_bkg.jpg'),
                            image: AssetImage('assets/image/white_bkg.jpg'),
                            fit: BoxFit.scaleDown,
                          )
                              : Container(
                            width: SizeConfig.screenWidth / 2,
                            child: CachedNetworkImage(
                              imageUrl: '${widget.plpCard.imageUrls![0]}?w=300',
                              maxWidthDiskCache: 345,
                              placeholder: (context, url) => Container(
                                width: SizeConfig.screenWidth / 2,
                                height: 250,
                                color: Colors.transparent,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xffcd3a62),
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ),
                              errorWidget:
                                  (context, url, error) =>
                                  Container(
                                    width: SizeConfig.screenWidth / 2,
                                  ),
                            ),
                          ),
                          widget.plpCard.messageOnImage!.length > 0
                              ? Positioned(
                            bottom: 2,
                            left: 2,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                color: Color(0xfff2ebd3),
                                child: Text(
                                  '${widget.plpCard.messageOnImage![0]}',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                      fontSize: textScale>1 ? 1.6 * SizeConfig.textMultiplier : 1.5 * SizeConfig.textMultiplier),
                                )),
                          )
                              : Container(),
                        ],
                      ),
                      //Brand Name
                      // Padding(
                      //   padding: EdgeInsets.only(top: 4.0),
                      //   child: Container(
                      //     width: SizeConfig.screenWidth / 2.5,
                      //     child: Text(
                      //       '${widget.plpCard.brandName}',
                      //       textAlign: TextAlign.start,
                      //       style: TextStyle(
                      //           fontFamily: 'RecklessNeue',
                      //           color: Colors.black,
                      //           fontSize: textScale>1 ? 1.4 * SizeConfig.textMultiplier : 1.8 * SizeConfig.textMultiplier,
                      //           overflow: TextOverflow.ellipsis,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        width: SizeConfig.screenWidth / 2.5,
                        height: 19,
                        child: Text(
                          '${widget.plpCard.name}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'RecklessNeue',
                            color: Colors.black,
                            fontSize: textScale>1 ? 1.3 * SizeConfig.textMultiplier : 1.7 * SizeConfig.textMultiplier,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '₹${numberFormat.format(widget.plpCard.maxRetailPrice!.round())}',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black,
                                  fontSize: textScale>1 ? 1.3 * SizeConfig.textMultiplier : 1.7 * SizeConfig.textMultiplier,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            SizedBox(
                              width: 2 * SizeConfig.widthMultiplier,
                            ),
                            Text(
                              widget.plpCard.maxRetailPrice! <
                                      widget.plpCard.maxRegularPrice!
                                  ? '₹${numberFormat.format(widget.plpCard.maxRegularPrice!.round())}'
                                  : '',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.grey,
                                  fontSize: textScale>1 ? 1.2 * SizeConfig.textMultiplier : 1.5 * SizeConfig.textMultiplier,
                                  overflow: TextOverflow.ellipsis,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            SizedBox(
                              width: 2 * SizeConfig.widthMultiplier,
                            ),
                            widget.plpCard.discount == null
                                ? Text(
                                    '',
                                  )
                                : Text(
                                    '${widget.plpCard.discount}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.green,
                                      fontSize: textScale>1 ? 1.1 * SizeConfig.textMultiplier : 1.5 * SizeConfig.textMultiplier,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      onTap: () {
                        wishInitState(widget.plpCard.isWishlisted ?? false,
                            widget.plpCard.productId!);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(.5),
                        radius: 12,
                        child: widget.plpCard.isWishlisted == false ||
                                widget.plpCard.isWishlisted == null
                            ? SvgPicture.asset(
                          'assets/icons/addWishlist.svg',
                          height: 18,
                          width: 18,
                        )
                            : SvgPicture.asset(
                          'assets/icons/wishlisted.svg',
                          height: 18,
                          width: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
