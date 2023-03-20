import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ouat/data/models/promoListModel.dart';
import 'package:ouat/data/models/showCartModel.dart';
import '../../size_config.dart';
import './promo_state.dart';
import './promo_event.dart';
import './promo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/widgets/general_dialog.dart';


class PromoScreen extends StatefulWidget {
  static const ROUTE_NAME = 'PromoScreen';
  List<ShowShoppingCartData>? cart_items;
  double? cart_value;
  var callback;

   PromoScreen({this.cart_items, this.cart_value, this.callback});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  late PromoBloc promoBloc = PromoBloc(SearchInitState());

  PromoListModel promoListModel = PromoListModel();
  String promocode = "";
  String promoName = "";
  final _promoKey = GlobalKey<FormState>();
  final TextEditingController promo_controller = new TextEditingController();


  @override
  void initState() {
    // categoryBloc = BlocProvider.of<CategoryBloc>(context);
    getInitState();
    print(widget.cart_items);
    super.initState();
  }

  getInitState() async {
    promoBloc.add(LoadEvent());
  }

  checkPromoState(List<ShowShoppingCartData>? cart_items, double cart_value, String promo) async {
    promoBloc.add(LoadingEvent(cart_items, cart_value, promo));
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
                Icons.arrow_back,
                color: Colors.black
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: false,
          title: Text(
            'Coupon Codes',
            style: TextStyle(
                fontFamily: 'RecklessNeue',
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: Container(
            padding:
            EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: BlocProvider(
              create: (context) => promoBloc,
              child: BaseBlocListener(
                  bloc: promoBloc,
                  listener: (context, state) {

                    if (state is CompletedState) {
                      promoListModel = state.promoListModel!;
                    }

                    if (state is CompletedCheckState) {
                      if(state.promoValidModel!.message![0].msgType == "INFO"){
                        widget.callback(state.promoValidModel!.data!.promoDiscount, state.promoValidModel!.message, promocode, promoName, state.promoValidModel!.data!.discountType);
                      }
                      else{
                        widget.callback(0, state.promoValidModel!.message, promocode, promoName, state.promoValidModel!.data);
                      }
                      Navigator.pop(context);
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
                      bloc: promoBloc,
                      condition: (oldState, currentState) {
                        return !(BaseBlocBuilder.isBaseState(currentState));
                      },
                      builder: (BuildContext context, BaseState state) {

                        if (promoListModel.data != null) {
                          return SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            height: 5.5 * SizeConfig.heightMultiplier,
                                            child: Form(
                                              key: _promoKey,
                                              child: TextFormField(
                                                controller: promo_controller,
                                                textAlign: TextAlign.start,
                                                cursorColor: Color(0xffcd3a62),
                                                decoration: InputDecoration(
                                                  hintText: 'Apply Promo',
                                                  hintStyle: TextStyle(
                                                    fontSize: textScale >1 ? 2*SizeConfig.textMultiplier : 2.4*SizeConfig.textMultiplier,
                                                  ),
                                                  contentPadding: EdgeInsets.all(10),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(Radius.zero),
                                                      borderSide: BorderSide(color: Colors.transparent)
                                                  ),
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.zero),
                                                      borderSide: BorderSide(color: Colors.transparent)
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                promocode = promo_controller.text.toString();
                                              });
                                              checkPromoState(widget.cart_items,
                                                  widget.cart_value!, promo_controller.text.toString());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.zero
                                              ),
                                                primary: Colors.black,
                                              fixedSize: Size(SizeConfig.screenWidth / 4, 5 * SizeConfig.heightMultiplier)
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Center(
                                              child: Text(
                                                'Apply',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: const Color(0xfff9d8d8),
                                  thickness: 2,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: promoListModel.data!.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 3,
                                          child: ListTile(
                                            onTap: (){
                                              setState(() {
                                                promocode = promoListModel.data![index].code!;
                                                promoName = promoListModel.data![index].name!;
                                              });
                                              checkPromoState(
                                                  widget.cart_items,
                                                  widget.cart_value!,
                                                  promoListModel.data![index].code!
                                              );
                                            },
                                            title: Text(
                                                '${promoListModel.data![index].name}',
                                              style: TextStyle(
                                                  fontFamily: 'RecklessNeue',
                                                fontWeight: FontWeight.bold,
                                                fontSize: textScale >1 ? 2*SizeConfig.textMultiplier : 2.4*SizeConfig.textMultiplier,
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(10),
                                            subtitle: Text(
                                                '${promoListModel.data![index].description}',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: textScale >1 ? 1.8*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier,
                                              ),
                                              maxLines: 3,
                                            ),
                                            trailing: Text(
                                                '${promoListModel.data![index].code}',
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                color: Color(0xffcd3a62),
                                                  fontWeight: FontWeight.bold,
                                                fontSize: textScale >1 ? 1.8*SizeConfig.textMultiplier : 2.2*SizeConfig.textMultiplier,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            height: 5 * SizeConfig.heightMultiplier,
                                            child: Form(
                                              key: _promoKey,
                                              child: TextFormField(
                                                controller: promo_controller,
                                                textAlign: TextAlign.start,
                                                cursorColor: Color(0xffcd3a62),
                                                decoration: InputDecoration(
                                                  hintText: 'Apply Promo',
                                                  contentPadding: EdgeInsets.all(10),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.zero),
                                                      borderSide: BorderSide(color: Colors.transparent)
                                                  ),
                                                  fillColor: Colors.grey[300],
                                                  filled: true,
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.zero),
                                                      borderSide: BorderSide(color: Colors.transparent)
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                promocode = promo_controller.text.toString();
                                              });
                                              checkPromoState(widget.cart_items,
                                                  widget.cart_value!, promo_controller.text.toString());
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.zero
                                                ),
                                                primary: Colors.black,
                                                fixedSize: Size(SizeConfig.screenWidth / 4, 5 * SizeConfig.heightMultiplier)
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Center(
                                              child: Text(
                                                'Apply',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Looks like no active promo code exists in our system.'
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      })),
            ))
    );
  }
}

