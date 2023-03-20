import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/screens/Cart/cart_screen.dart';
import 'package:ouat/screens/WishList/wishlist_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:ouat/widgets/badge.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AppBarCustom extends StatefulWidget {
  final Function(bool)? onTapSearch;
  var callback;
  String? screen;
  String? query;
  String? totalHits;
  bool? search;
  int count;
  AppBarCustom({
    @required this.onTapSearch,
    this.callback,
    this.screen,
    this.query,
    this.totalHits,
    this.search,
    this.count = 0
  });

  @override
  _AppBarCustomState createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Container(
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            //top: 30,
            //top: MediaQuery.of(context).size.height * 0.045,
            bottom: 10.0
        ),
        color: Colors.white,
        child: Container(
          height: 50,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: widget.screen == "Home" ?
                Image.asset(
                  "assets/icons/taggd_new_logo.png",
                  height: 130,
                  width: 130,
                ) :
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth:  SizeConfig.screenWidth/3.5,
                        ),
                        child: Text(
                          widget.query!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'RecklessNeue',
                              color: Colors.black,
                              fontSize: textScale>1 ? 1.9  * SizeConfig.textMultiplier : 2.2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${widget.totalHits} Items',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.black,
                        fontSize: textScale>1 ? 1.5  * SizeConfig.textMultiplier : 1.9 * SizeConfig.textMultiplier,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    widget.screen == "Search" ?
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )) :
                    Container(height: 0,),
                    widget.screen == "Search" ?
                    Spacer() : Container(height: 0,),
                    InkWell(
                      onTap: () {
                        widget.onTapSearch!(true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                         height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                    SizedBox(width:3.0),
                    widget.search ?? false ?
                    Badge(
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, CartActivity.ROUTE_NAME,
                                arguments: {
                                  "callback": (value) {
                                    if (value) {
                                      widget.callback(true);
                                    }
                                  },
                                  "pdp": true
                                }).then((value){
                              updateCartItem(true);
                              //widget.callback(true);
                            });
                          },
                          icon: SvgPicture.asset('assets/icons/bag.svg'),
                        ),
                        widget.count == 0 ? "" : widget.count.toString(),
                        Color(0xffcd3a62),
                        8,
                        8):
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, WishListScreen.ROUTE_NAME, arguments: {
                          "callback": (value){
                            widget.callback(true);
                          },
                        });
                      },
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.widthMultiplier,
                              vertical: 8.0
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/wishlist.svg',
                            height: 25,
                            width: 25
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateCartItem(bool value) async {
    if(value){
      OrderStatusModel? orderStatusModel = await DataRepo.getInstance().userRepo.getItemsNumber();
      log(orderStatusModel.data.toString());
      var cartItems = orderStatusModel.data == null ? 0 : orderStatusModel.data!;
      /*setState(() {
        widget.count = cartItems;
      });*/
    }
  }

  @override
  void initState() {
    updateCartItem(true);
    super.initState();
  }
}
