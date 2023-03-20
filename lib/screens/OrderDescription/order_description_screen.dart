import 'package:flutter/material.dart';
import 'package:ouat/data/models/message.dart';
import 'package:ouat/data/models/orderDescriptionModel.dart';
import 'package:ouat/screens/Splash/splash_screen.dart';
import 'package:ouat/widgets/OrderDetailItem/orderDetailItem_screen.dart';
import 'package:ouat/widgets/order_summary.dart';
import '../../size_config.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:ouat/widgets/message_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import './order_description_state.dart';
import './order_description_event.dart';
import './order_description_bloc.dart';

class OrderDescriptionScreen extends StatefulWidget {
  static const String ROUTE_NAME = "OrderDescriptionScreen";
  String? order_number;
  var callback;
  OrderDescriptionScreen({
    required this.order_number,
    this.callback
  });

  @override
  State<OrderDescriptionScreen> createState() => _OrderDescriptionScreenState();
}

class _OrderDescriptionScreenState extends State<OrderDescriptionScreen> {
  late OrderDescriptionBloc orderDescriptionBloc = OrderDescriptionBloc(SearchInitState());
  OrderDescriptionModel? orderDescriptionModel = OrderDescriptionModel();
  var callBackFunction;
  List<Message>? msg;


  @override
  void initState() {
    // categoryBloc = BlocProvider.of<CategoryBloc>(context);
    getOrderDescriptionInitState();
    super.initState();
  }



  getOrderDescriptionInitState() async {
    orderDescriptionBloc.add(LoadEvent(widget.order_number));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: Container(
            padding:
            EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: BlocProvider(
              create: (context) => orderDescriptionBloc,
              child: BaseBlocListener(
                  bloc: orderDescriptionBloc,
                  listener: (context, state) {

                    if (state is CompletedState) {
                      orderDescriptionModel = state.orderDescriptionModel;
                      if(orderDescriptionModel!.data!.orderType == "MIGRATION"){
                        Navigator.pushNamedAndRemoveUntil(context, SplashActivity.ROUTE_NAME, (r) => false);
                      }
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
                      bloc: orderDescriptionBloc,
                      condition: (oldState, currentState) {
                        return !(BaseBlocBuilder.isBaseState(currentState));
                      },
                      builder: (BuildContext context, BaseState state) {

                        if (orderDescriptionModel!.data != null) {
                          return Scaffold(
                            body: CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  leading: IconButton(
                                    icon: Icon(
                                        Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  backgroundColor: Colors.white,
                                  shadowColor: const Color(0xffffd2d2),
                                  centerTitle: false,
                                  pinned: true,
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order No. ${orderDescriptionModel!.data!.customOrderNumber}",
                                        style: TextStyle(
                                            fontFamily: 'RecklessNeue',
                                            fontWeight: FontWeight.bold,
                                            fontSize: textScale>1 ? 1.5*SizeConfig.textMultiplier : 2*SizeConfig.textMultiplier,
                                            color: Colors.black
                                        ),
                                      ),
                                      Text(
                                        "Placed on ${orderDescriptionModel!.data!.orderDate}",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 1.4*SizeConfig.textMultiplier,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if(orderDescriptionModel!.message!.first.msgType != "INFO")
                                SliverToBoxAdapter(
                                  child: MessageScreen(orderDescriptionModel!.message!),
                                ),
                                if(msg != null)
                                  SliverToBoxAdapter(
                                    child: MessageScreen(
                                        msg
                                    ),
                                  ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                          (context , index){
                                        return
                                          OrderDetailItemScreen(
                                              orderDescriptionModel!.data!.orderItem![index],
                                              orderDescriptionModel!.data!.customOrderNumber.toString(),
                                              (value, message){
                                                getOrderDescriptionInitState();
                                                setState(() {
                                                  msg = message;
                                                });
                                                widget.callback(true);
                                              }
                                          );
                                      },
                                      childCount: orderDescriptionModel!.data!.orderItem!.length
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
                                                  fontSize: 2.2*SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  orderDescriptionModel!.data!.shippingAddress!.fullName!,
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
                                                  text: '${orderDescriptionModel!.data!.shippingAddress!.address}\n',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.black,
                                                    fontSize: 1.8*SizeConfig.textMultiplier,
                                                  ),
                                                  children: <TextSpan>[
                                                    if(orderDescriptionModel!.data!.shippingAddress!.landmark != "")
                                                    TextSpan(
                                                      text: '${orderDescriptionModel!.data!.shippingAddress!.landmark}\n',
                                                    ),
                                                    TextSpan(
                                                      text: '${orderDescriptionModel!.data!.shippingAddress!.city}, ',
                                                    ),
                                                    TextSpan(
                                                      text: '${orderDescriptionModel!.data!.shippingAddress!.state}, ',
                                                    ),
                                                    TextSpan(
                                                      text: '${orderDescriptionModel!.data!.shippingAddress!.pincode}\n',
                                                    ),
                                                    TextSpan(
                                                      text: '${orderDescriptionModel!.data!.shippingAddress!.mobile}',
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
                                              subtotal: orderDescriptionModel!.data!.priceSummary!.oderTotal,
                                              platformDiscount: orderDescriptionModel!.data!.priceSummary!.platformDiscount!,
                                              promoDiscount: orderDescriptionModel!.data!.priceSummary!.promoDiscount,
                                              promoCode: orderDescriptionModel!.data!.priceSummary!.promocode,
                                              credits: orderDescriptionModel!.data!.priceSummary!.creditApplied,
                                              creditsType: "Credits Applied",
                                              deliveryCharges: orderDescriptionModel!.data!.priceSummary!.shippingCharge,
                                              shippingMessage: null,
                                              totalSavings: 0.0,
                                              orderTotal: orderDescriptionModel!.data!.priceSummary!.orderPayable,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      })),
            ))
    );
  }
}
