import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/showCartModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/screens/Login/login_screen.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:ouat/screens/Cart/cart_bloc.dart';
import 'package:ouat/screens/Cart/cart_event.dart';
import 'package:ouat/screens/Cart/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import '../../size_config.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';



class CartItem extends StatefulWidget {
  ShowShoppingCartData? showShoppingCartData;
  var callback;
  CartItem({
    this.showShoppingCartData,
    this.callback
});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late CartBloc cartBloc = CartBloc(SearchCartInitState());
  bool slider = false;
  var removeFromCartPayload;
  var addToWishlistPayload;
  var addToCartPayload;
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  bool outOfStock = false;
  bool lowInventory = false;



  deleteInitState(String sku) async {
    cartBloc.add(LoadingEvent(sku));
    NetcoreEvents.removeFromCartTrack(widget.showShoppingCartData!.productId!);
    AppsFlyer.removeFromCartTrack(widget.showShoppingCartData!.productId!);
  }

  wishInitState(int product_id) async {
    CustomerDetail? customerDetail =
    DataRepo.getInstance().userRepo.getSavedUser();
    if (customerDetail == null) {
      Navigator.pushNamed(context, LoginScreen.ROUTE_NAME, arguments: {
        "callback": (value) {
          if (value != null) {
          }
        }
      }).then((value) {
        cartBloc.add(WishlistingEvent(product_id));
      });
    } else {
      cartBloc.add(WishlistingEvent(product_id));
    }
    NetcoreEvents.addToWishlistTrack(
        widget.showShoppingCartData!.category!,
        widget.showShoppingCartData!.subCategory!,
        widget.showShoppingCartData!.defaultImageUrl!,
        widget.showShoppingCartData!.productType!,
        widget.showShoppingCartData!.productName!,
        widget.showShoppingCartData!.retailPrice!,
        widget.showShoppingCartData!.regularPrice!,
        widget.showShoppingCartData!.size!,
        widget.showShoppingCartData!.itemDiscount!.toString());
    AppsFlyer.addToWishlistTrack(
        widget.showShoppingCartData!.category!,
        widget.showShoppingCartData!.subCategory!,
        widget.showShoppingCartData!.defaultImageUrl!,
        widget.showShoppingCartData!.productType!,
        widget.showShoppingCartData!.productName!,
        widget.showShoppingCartData!.retailPrice!,
        widget.showShoppingCartData!.regularPrice!,
        widget.showShoppingCartData!.size!,
        widget.showShoppingCartData!.itemDiscount!.toString());
    NetcoreEvents.removeFromCartTrack(widget.showShoppingCartData!.productId!);
    AppsFlyer.removeFromCartTrack(widget.showShoppingCartData!.productId!);
  }

  updateCartState(String sku, String quantity) async{
    cartBloc.add(ProgressEvent(sku, quantity));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cartBloc,
      child: BaseBlocListener(
          bloc: cartBloc,
          listener: (context, state) {

            if(state is NotAuthorisedState){
              Navigator.pushNamed(context, LoginScreen.ROUTE_NAME, arguments: {
                "callback": (value){
                  if(value != null){
                    if(value){
                      wishInitState(widget.showShoppingCartData!.productId!);
                    }
                  }
                }
              });
            }

            if(state is WishlistingState){
              deleteInitState(widget.showShoppingCartData!.sku!);
            }



            if (state is CompletedCheckState) {
              widget.callback(true);
            }

            if (state is CompletedAddingState) {
              if(state.addToCartModel!.message![0].msgType != "INFO"){
                Fluttertoast.showToast
                  (
                    msg: state.addToCartModel!.success == false
                        ? state.addToCartModel!.message![0].msgText!
                        : state.addToCartModel!.message![0].msgText!,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xffcd3a62),
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
              else{
                widget.callback(true);
              }
            }
            if(state is ErrorCartState){
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
                if(true){
                  return Card(
                    elevation: 2,
                    shadowColor: const Color(0xffffd2d2),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, ProductDescriptionScreen.ROUTE_NAME, arguments: {
                              "pid": '${widget.showShoppingCartData!.productId}',
                              "callback": (value){
                                if(!value){
                                  deleteInitState(widget.showShoppingCartData!.sku!);
                                  wishInitState(widget.showShoppingCartData!.productId!);
                                }
                              },
                            }).then((value) => widget.callback(true));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.heightMultiplier,
                                    horizontal: 2*SizeConfig.widthMultiplier
                                ),
                                child: Container(
                                  width: 30*SizeConfig.widthMultiplier,
                                  height: 25*SizeConfig.heightMultiplier,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fitWidth,
                                    imageUrl: '${widget.showShoppingCartData!.defaultImageUrl}?w=345' ??
                                        "",
                                    maxWidthDiskCache: 345,
                                    errorWidget:
                                        (context, url, error) =>
                                        Container(),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 0.5*SizeConfig.screenWidth,
                                    child: Padding(
                                      padding:  EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        "${widget.showShoppingCartData!.productName}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontFamily: 'RecklessNeue',
                                            fontSize: 2 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.showShoppingCartData!.size == "" ?
                                      Container() :
                                  Text("Size : ${widget.showShoppingCartData!.size}"),
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            "₹${numberFormat.format(widget.showShoppingCartData!.retailPrice!.round())}",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                                fontSize: 1.75 *
                                                    SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold
                                            )
                                        ),
                                        widget.showShoppingCartData!.regularPrice! > widget.showShoppingCartData!.retailPrice! ?
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              "₹${numberFormat.format(widget.showShoppingCartData!.regularPrice!.round())}",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Colors.grey,
                                                  fontSize: 1.75 *
                                                      SizeConfig.textMultiplier,
                                                  decoration:
                                                  TextDecoration.lineThrough)
                                          ),
                                        ) :
                                        Container(),
                                        widget.showShoppingCartData!.itemDiscount == 0.0 ?
                                            Container():
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              "${((widget.showShoppingCartData!.itemDiscount!/widget.showShoppingCartData!.regularPrice!) * 100).round()}% OFF",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                  color: Colors.green,
                                                  fontSize: 1.75 *
                                                      SizeConfig.textMultiplier,
                                                  )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.showShoppingCartData!.priceChange == 0.0 ?
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                  ):
                                  Container(
                                    width: SizeConfig.screenWidth/2,
                                    child: Chip(
                                      backgroundColor: Colors.green[100],
                                      label: Text(
                                          'New Price: ${numberFormat.format(widget.showShoppingCartData!.priceChange!.round())}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.green,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 1.75 *
                                                SizeConfig.textMultiplier,
                                          )
                                      ),
                                      avatar: CircleAvatar(
                                        backgroundImage: AssetImage(
                                          "assets/image/Key_green.jpg",
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 2*SizeConfig.widthMultiplier,
                              ),
                            ],
                          ),
                        ),
                        if(widget.showShoppingCartData!.messageDetail != null)
                          widget.showShoppingCartData!.messageDetail!.msgType == "LOW_INVENTORY" ?
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                      '${widget.showShoppingCartData!.messageDetail!.msgText}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Color(0xffD73656),
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffD73656),
                                      ),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                ClipPath(
                                  clipper: TriangleClipper(),
                                  child: Container(
                                    color: Color(0xffD73656),
                                    height: 10,
                                    width: 20,
                                  ),
                                )
                              ],
                            ),
                          ):
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                          ),
                        Divider(
                          color: Color(0xffcd3a62),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: (){
                                deleteInitState(widget.showShoppingCartData!.sku!);
                              },
                                child: SvgPicture.asset(
                                  'assets/icons/delete.svg',
                                  height: 24,
                                  width: 24,
                                )
                            ),
                            InkWell
                              (
                              onTap: (){
                                wishInitState(widget.showShoppingCartData!.productId!);
                              },
                                child: SvgPicture.asset(
                                  'assets/icons/addWishlist.svg',
                                  height: 24,
                                  width: 24,
                                )
                            ),
                            if(widget.showShoppingCartData!.messageDetail != null)
                              widget.showShoppingCartData!.messageDetail!.msgType == "OUT_OF_STOCK" ?
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                        '${widget.showShoppingCartData!.messageDetail!.msgText}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Color(0xffD73656),
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color(0xffD73656),
                                        ),
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                ) :
                              Row(
                                children: [
                                  IconButton(
                                    // padding: EdgeInsets.all(2),
                                    //iconSize: 2*SizeConfig.textMultiplier,
                                      icon: SvgPicture.asset(
                                        'assets/icons/remove.svg',
                                        height: 24,
                                        width: 24,
                                        color: widget.showShoppingCartData!.quantity! == 1 ? Colors.grey[400] : Colors.black,
                                      ),
                                      onPressed: (){
                                        if(widget.showShoppingCartData!.quantity! > 1){
                                          updateCartState(widget.showShoppingCartData!.sku!, "-1");
                                        }
                                        else{
                                          null;
                                        }
                                      }
                                  ),
                                  Text('${widget.showShoppingCartData!.quantity}'),
                                  IconButton(
                                    //padding: EdgeInsets.all(2),
                                    //iconSize: 2*SizeConfig.textMultiplier,
                                      icon: SvgPicture.asset(
                                        'assets/icons/add.svg',
                                        height: 24,
                                        width: 24,
                                        color: Color(0xffcd3a62),
                                      ),
                                      onPressed: (){
                                        updateCartState(widget.showShoppingCartData!.sku!, "1");
                                      }
                                  ),
                                ],
                              ),
                            if(widget.showShoppingCartData!.messageDetail == null)
                              Row(
                                children: [
                                  IconButton(
                                    // padding: EdgeInsets.all(2),
                                    //iconSize: 2*SizeConfig.textMultiplier,
                                      icon: SvgPicture.asset(
                                        'assets/icons/remove.svg',
                                        height: 24,
                                        width: 24,
                                        color: widget.showShoppingCartData!.quantity! == 1 ? Colors.grey[400] : Colors.black,
                                      ),
                                      onPressed: (){
                                        if(widget.showShoppingCartData!.quantity! > 1){
                                          updateCartState(widget.showShoppingCartData!.sku!, "-1");
                                        }
                                        else{
                                          null;
                                        }
                                      }
                                  ),
                                  Text('${widget.showShoppingCartData!.quantity}'),
                                  IconButton(
                                    //padding: EdgeInsets.all(2),
                                    //iconSize: 2*SizeConfig.textMultiplier,
                                      icon: SvgPicture.asset(
                                        'assets/icons/add.svg',
                                        height: 24,
                                        width: 24,
                                        color: Color(0xffcd3a62),
                                      ),
                                      onPressed: (){
                                        updateCartState(widget.showShoppingCartData!.sku!, "1");
                                      }
                                  ),
                                ],
                              ),
                          ],
                        )
                      ],
                    ),
                  );
                }
                else{
                  return Container();
                }
              })),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

