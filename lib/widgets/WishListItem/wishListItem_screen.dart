import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/showWishListModel.dart';
import 'package:ouat/screens/ProductDescription/available_size_information.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:ouat/screens/WishList/wishlist_bloc.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:ouat/screens/WishList/wishlist_event.dart';
import 'package:ouat/screens/WishList/wishlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import '../../size_config.dart';
import 'package:intl/intl.dart';



class WishListItemScreen extends StatefulWidget {
  ShowWishListData data;
  var callback;

  WishListItemScreen(
    this.data,
      this.callback
  );

  @override
  _WishListItemScreenState createState() => _WishListItemScreenState();
}

class _WishListItemScreenState extends State<WishListItemScreen> {
  late WishListBloc wishListBloc = WishListBloc(SearchInitState());
  var addToCartPayload;
  ProductDescriptionModel? productDescriptionModel = ProductDescriptionModel();
  var callBackFunction;
  var removeFromWishlistPayload, sizePayload;
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');


  deleteInitState(int id) async {
    wishListBloc.add(LoadingEvent(id));
    NetcoreEvents.removeFromWishlistTrack(productDescriptionModel!.data!.productId!);
    AppsFlyer.removeFromWishlistTrack(productDescriptionModel!.data!.productId!);
  }

  sizeInitState(String id) async {
    wishListBloc.add(SizeEvent(id));
  }

  addToCartInitState(String sku, String quantity) async {
    wishListBloc.add(ProgressingEvent(sku, quantity));
    NetcoreEvents.removeFromWishlistTrack(productDescriptionModel!.data!.productId!);
    AppsFlyer.removeFromWishlistTrack(productDescriptionModel!.data!.productId!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => wishListBloc,
      child: BaseBlocListener(
          bloc: wishListBloc,
          listener: (context, state) {

            if(state is SizeState){
              productDescriptionModel = state.productDescriptionModel;
              _enterSize(context).then((value) {
                if(value != null){
                  callBackFunction(value);
                }
              });
            }
            if (state is CompletedCheckState) {
              widget.callback(true);
            }

            if(state is CompletedCartState){
              widget.callback(true);
            }

            if(state is ErrorState){
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
              bloc: wishListBloc,
              condition: (oldState, currentState) {
                return !(BaseBlocBuilder.isBaseState(currentState));
              },
              builder: (BuildContext context, BaseState state) {
                if(true){
                  return InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, ProductDescriptionScreen.ROUTE_NAME, arguments: {
                        "pid": '${widget.data.productId}',
                        "callback": (value){
                          if(!value){
                            deleteInitState(widget.data.productId!);
                          }
                        },
                      });
                    },
                    child: Card(
                      elevation: 7,
                      shadowColor: const Color(0xffffd2d2),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2*SizeConfig.heightMultiplier,
                                  vertical: 5
                                ),
                                child: Container(
                                  width: 25*SizeConfig.widthMultiplier,
                                  height: 20*SizeConfig.heightMultiplier,
                                  child: FadeInImage(
                                    image: NetworkImage(widget.data.productImage ??
                                        ""),
                                    placeholder: AssetImage('assets/image/white.jpeg'),
                                    fit: BoxFit.fitWidth,
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
                                    width: 0.3*SizeConfig.screenWidth,
                                    child: Padding(
                                      padding:  EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        "${widget.data.productName}",
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
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            "₹${widget.data.salePrice!}",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.black,
                                                fontSize: 1.5 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                        int.parse(widget.data.price!) > int.parse(widget.data.salePrice!) ?
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              "₹${widget.data.price!}",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Colors.grey,
                                                  fontSize: 1.5 *
                                                      SizeConfig.textMultiplier,
                                                  decoration:
                                                  TextDecoration.lineThrough)
                                          ),
                                        ) :
                                        Container(),
                                        widget.data.discount == 0.0 ?
                                        Container():
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              "${(widget.data.discount!/int.parse(widget.data.price!) * 100).round()}% OFF",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.green,
                                                fontSize: 1.5 *
                                                    SizeConfig.textMultiplier,
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //widget.data.messageList == null ||  widget.data.messageList == [] ?
                                  /*Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                        "OUT OF STOCK",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 1.75 *
                                                SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  )*/
                                      /*: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                        "${widget.data.messageList}",
                                        style: TextStyle(
                                          color: Color(0xffcd3a62),
                                          fontSize: 1.75 *
                                              SizeConfig.textMultiplier,
                                        )
                                    ),
                                  )*/
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    child: SvgPicture.asset(
                                      'assets/icons/delete.svg',
                                      height: 24,
                                      width: 24,
                                    ),
                                  onTap: (){
                                    deleteInitState(widget.data.productId!);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffcd3a62),
                                  minimumSize: Size(
                                      SizeConfig.screenWidth,
                                      5*SizeConfig.heightMultiplier
                                  )
                              ),
                              onPressed: () {
                                sizeInitState(widget.data.productId!.toString());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'ADD TO CART',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else{
                  return Container();
                }
              })),
    );
  }

  Future _enterSize(BuildContext ctx) async{
    await showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: SizeConfig.screenHeight/5
      ),
      context: ctx,
      builder: (_) {
         if(productDescriptionModel!.data!.sizeChart!.length < 1){
           if (productDescriptionModel!.data!.inventory!.inStock ==
               true){
             addToCartInitState(productDescriptionModel!
                 .data!.skuResponse![0].sku!, "1");
           }
           else{
             final snackBar = SnackBar(
               backgroundColor: Color(0xffcd3a62),
               duration: Duration(seconds: 3),
               content: Text(
                 'OUT OF STOCK',
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
             Navigator.pop(ctx,true);
             ScaffoldMessenger.of(context).showSnackBar(snackBar);
           }
          deleteInitState(widget.data.productId!);
          NetcoreEvents.addToCartTrack(productDescriptionModel!.data!.category!,
              productDescriptionModel!.data!.subCategory!,
              productDescriptionModel!.data!.images![0],
              productDescriptionModel!.data!.productSubtype!,
              productDescriptionModel!.data!.productType!,
              productDescriptionModel!.data!.name!,
              productDescriptionModel!.data!.price!,
              productDescriptionModel!.data!.regularPrice!,
              productDescriptionModel!.data!.skuResponse![0].size!,
              productDescriptionModel!.data!.discount!);
          AppsFlyer.addToCartTrack(productDescriptionModel!.data!.category!,
              productDescriptionModel!.data!.subCategory!,
              productDescriptionModel!.data!.images![0],
              productDescriptionModel!.data!.productSubtype!,
              productDescriptionModel!.data!.productType!,
              productDescriptionModel!.data!.name!,
              productDescriptionModel!.data!.price!,
              productDescriptionModel!.data!.regularPrice!,
              productDescriptionModel!.data!.skuResponse![0].size!,
              productDescriptionModel!.data!.discount!);
          Navigator.pop(ctx,true);
          return Center(
              child: CircularProgressIndicator(
                color: Color(0xffcd3a62),
              )
          );
        }
        else{
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AvailableSize(
                productDescriptionModel!
                    .data!.sizeChart![0],
                productDescriptionModel!
                    .data!.skuResponse, (value) {
              if (value != null) {
                if (productDescriptionModel!.data!.inventory!.inStock ==
                    true){
                  if(productDescriptionModel!.data!
                      .skuResponse![value].inventoryCount! >
                      0){
                    addToCartInitState(productDescriptionModel!
                        .data!.skuResponse![value].sku!, "1");
                    deleteInitState(widget.data.productId!);
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
                  else{
                    final snackBar = SnackBar(
                      backgroundColor: Color(0xffcd3a62),
                      duration: Duration(seconds: 3),
                      content: Text(
                        'OUT OF STOCK',
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
                    //Navigator.pop(ctx,true);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                else{
                  final snackBar = SnackBar(
                    backgroundColor: Color(0xffcd3a62),
                    duration: Duration(seconds: 3),
                    content: Text(
                      'OUT OF STOCK',
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
                  //Navigator.pop(ctx,true);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                Navigator.pop(ctx,true);
              }
            }),
          );
        };
      },
    ).then((value) {
      if(value!=null){
        callBackFunction(value);
      }
    });
  }
}

