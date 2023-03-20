import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ouat/data/models/cancelReasonModel.dart';
import 'package:ouat/data/models/cancelReturnItemModel.dart';
import 'package:ouat/data/models/orderDescriptionModel.dart';
import 'package:ouat/data/models/sizeExchangingModel.dart';
import 'package:ouat/screens/OrderDescription/order_description_bloc.dart';
import 'package:ouat/screens/OrderDescription/order_description_state.dart';
import 'package:ouat/screens/OrderDescription/order_description_event.dart';
import 'package:ouat/screens/ProductDescription/product_description_screen.dart';
import 'package:ouat/size_config.dart';
import 'package:im_stepper/stepper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/widgets/OrderDetailItem/available_sizes.dart';
import 'package:ouat/widgets/general_dialog.dart';
import 'package:intl/intl.dart';


class OrderDetailItemScreen extends StatefulWidget {
  OrderItem? orderItem;
  String orderNumber;
  var callback;
  OrderDetailItemScreen(this.orderItem,this.orderNumber, this.callback);

  @override
  State<OrderDetailItemScreen> createState() => _OrderDetailItemScreenState();
}

class _OrderDetailItemScreenState extends State<OrderDetailItemScreen> {
  var _expandTrack = false;
  int activeStep = 0;
  late OrderDescriptionBloc orderDescriptionBloc = OrderDescriptionBloc(SearchInitState());
  CancelReturnItemModel? cancelReturnItemModel = CancelReturnItemModel();
  CancelReasonModel? cancelReasonModel = CancelReasonModel();
  SizeExchangingModel? sizeExchangeModel = SizeExchangingModel();
  var callBackFunction;
  var selectedIndex;
  String actionType = "";
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  bool _credits = false;
  bool _online = false;
  bool _expandReason = false;
  bool _expandRefund = false;



  @override
  void initState() {
    for(int i = 0; i<widget.orderItem!.trackingDetail!.mileStones!.length; i++){
      if(widget.orderItem!.trackingDetail!.mileStones![i].isCurrentStatus == true)
        activeStep = i;
    }
    selectedIndex = -1;
  }

  cancelInitState() async {
    orderDescriptionBloc.add(LoadingEvent(widget.orderNumber));
  }

  cancelItemInitState(int order_item_id, String sku, int reason_id, String refund_type) async {
    orderDescriptionBloc.add(ProcessingEvent(order_item_id, sku, reason_id, refund_type));
  }

  returnInitState(int order_item_id, String sku, int reason_id, String refund_type) async {
    orderDescriptionBloc.add(ProcessEvent(order_item_id, sku, reason_id, refund_type));
  }

  returnItemInitState() async {
    orderDescriptionBloc.add(ProgressEvent(widget.orderNumber));
  }

  exchangeInitState() async {
    orderDescriptionBloc.add(ExchangeEvent(widget.orderNumber));
  }

  exchangeItemInitState(int order_item_id, String sku, int reason_id) async {
    orderDescriptionBloc.add(ProgressingEvent(order_item_id, sku, reason_id));
  }

  sizeExchangeItemInitState(int order_item_id){
    orderDescriptionBloc.add(SizeExchangeEvent(order_item_id));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => orderDescriptionBloc,
      child: BaseBlocListener(
          bloc: orderDescriptionBloc,
          listener: (context, state) {

            if (state is DoneState) {
              widget.callback(true, state.cancelReturnItemModel!.message);
            }

            if(state is ExchangeState){
              widget.callback(true, state.sizeExchangedModel!.message);
            }

            if(state is SizeExchangeState){
              sizeExchangeModel = state.sizeExchangeModel;
              if(sizeExchangeModel!.data!.skuResponse!.length == 1){
                if (sizeExchangeModel!.data!
                    .skuResponse![0].inventory! >
                    0){
                  exchangeItemInitState(widget.orderItem!.orderItemId!, sizeExchangeModel!.data!
                      .skuResponse![0].sku!,
                      cancelReasonModel!.data!.reasons![selectedIndex].reasonId!);
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
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                callBackFunction(true);
              }
              else{
                _enterSize(context);
              }
            }
            if(state is CancelledReasonState){
              cancelReasonModel = state.cancelReasonModel;
              selectedIndex = -1;
              _enterReasonRefund(context, widget.orderItem!.orderItemId, widget.orderItem!.itemDetail!.sku, actionType).then((value) {
                if(value != null){
                  callBackFunction(value);
                }
              });
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
                if(true){
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${widget.orderItem!.orderStatus}',
                              style: TextStyle(
                                  fontFamily: 'RecklessNeue',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              '${widget.orderItem!.orderStatusDate}',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.popAndPushNamed(context, ProductDescriptionScreen.ROUTE_NAME, arguments: {
                            "pid": '${widget.orderItem!.itemDetail!.productId}'
                          });
                        },
                        child: Card(
                          child: Container(
                            width: SizeConfig.screenWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: SizeConfig.screenWidth/2,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    widget.orderItem!.itemDetail!.imageUrl ??
                                        "",
                                    placeholder: (context,
                                        url) =>
                                        Container(),
                                    errorWidget:
                                        (context, url, error) =>
                                        Container(),
                                  ),
                                ),
                                Container(
                                  width: 0.35*SizeConfig.screenWidth,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: SizeConfig.screenWidth/3,
                                        child: Text(
                                          '${widget.orderItem!.itemDetail!.itemName}',
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontFamily: 'RecklessNeue',
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: 'Quantity : ',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 2 * SizeConfig.textMultiplier,
                                                color: Colors.black
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${widget.orderItem!.itemDetail!.quantity}\n',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                  fontSize: 2 * SizeConfig.textMultiplier,
                                                ),
                                              ),
                                              if(widget.orderItem!.itemDetail!.size != "")
                                              TextSpan(
                                                text: 'Size : ',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  fontSize: 2 * SizeConfig.textMultiplier,
                                                ),
                                              ),
                                              if(widget.orderItem!.itemDetail!.size != "")
                                              TextSpan(
                                                text: '${widget.orderItem!.itemDetail!.size}\n',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                  fontSize: 2 * SizeConfig.textMultiplier,
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                      if(widget.orderItem!.itemDetail!.itemPayable != 0)
                                      Text(
                                        "₹${numberFormat.format(widget.orderItem!.itemDetail!.itemPayable!.round())}",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                          fontSize: 2 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      widget.orderItem!.actionButton!.length == 0 ?
                      Container() : Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                          widget.orderItem!.actionButton!.map(
                                (e) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  minimumSize: Size(
                                      0.35*SizeConfig.screenWidth,
                                      4*SizeConfig.textMultiplier
                                  )
                              ),
                              onPressed: () {
                                if(e.actionType == 'CANCEL'){
                                  cancelInitState();
                                }
                                else if(e.actionType == 'RETURN'){
                                  returnItemInitState();
                                }
                                else if(e.actionType == 'EXCHANGE'){
                                  exchangeInitState();
                                }
                                else if(e.actionType == 'TRACK'){
                                  setState(() {
                                    _expandTrack = !_expandTrack;
                                  });
                                }
                                setState(() {
                                  actionType = e.actionType!;
                                });
                                //widget.callback(widget.orderItem!.orderItemId, widget.orderItem!.itemDetail!.sku, e.actionType);
                              },
                              child: Text(
                                '${e.actionType}',
                                style: TextStyle(
                                    color: Color(0xffcd3a62),
                                    fontSize: 1.8*SizeConfig.textMultiplier
                                ),
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                      if(_expandTrack && widget.orderItem!.trackingDetail != null)
                        Card(
                          child: Column(
                            children: [
                              widget.orderItem!.trackingDetail!.additionalDetail!.courierCompany == "" ?
                              Container() :
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Track On: ',
                                      style: TextStyle(
                                          fontFamily: 'RecklessNeue',
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.textMultiplier * 2
                                      ),
                                    ),
                                    Text(
                                      '${widget.orderItem!.trackingDetail!.additionalDetail!.courierCompany}',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: SizeConfig.textMultiplier * 2
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              widget.orderItem!.trackingDetail!.additionalDetail!.awb == "" ?
                              Container() :
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Your AWB Number: ',
                                      style: TextStyle(
                                          fontFamily: '   v',
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.textMultiplier * 2
                                      ),
                                    ),
                                    Text(
                                      '${widget.orderItem!.trackingDetail!.additionalDetail!.awb}',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: SizeConfig.textMultiplier * 2
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight/2,
                                    width: SizeConfig.screenWidth/6,
                                    child: IconStepper(
                                      direction: Axis.vertical,
                                      enableNextPreviousButtons: false,
                                      enableStepTapping: false,
                                      stepColor: Colors.white,
                                      activeStepColor: Color(0xffcd3a62),
                                      activeStepBorderColor: Colors.white,
                                      activeStepBorderWidth: 0.0,
                                      activeStepBorderPadding: 0.0,
                                      lineColor: Color(0xffcd3a62),
                                      lineLength: 70.0,
                                      lineDotRadius: 2.0,
                                      stepRadius: 16.0,
                                      activeStep: activeStep,
                                      icons: widget.orderItem!.trackingDetail!.mileStones!.map(
                                              (e) => Icon(
                                            e.isCurrentStatus == true ?
                                            Icons.check :
                                            Icons.clear,
                                            color: e.isCurrentStatus == true ?
                                            Colors.white :
                                            Color(0xffcd3a62),
                                          )
                                      ).toList(),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: widget.orderItem!.trackingDetail!.mileStones!.length,
                                        itemBuilder: (context, index){
                                          return ListTile(
                                            contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                                            title: Text(
                                                "${widget.orderItem!.trackingDetail!.mileStones![index].label}"
                                            ),
                                            subtitle: widget.orderItem!.trackingDetail!.mileStones![index].date == "" ?
                                            Container() :
                                            Text(
                                                "${widget.orderItem!.trackingDetail!.mileStones![index].date}"
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                  /*Container(
                                    height: SizeConfig.screenHeight/3,
                                    width: SizeConfig.screenWidth/3,
                                    child: RiveAnimation.network(
                                      'https://cdn.rive.app/animations/vehicles.riv',
                                    ),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }
                else{
                  return Container();
                }
              })),
    );
  }

  Future _enterReasonRefund(BuildContext context, var orderItemId, var sku, var actionType) async{
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ExpansionTile(
                      onExpansionChanged: (value){
                        setState(() {
                          _expandReason = !_expandReason;
                        });
                      },
                      title: Text(
                        'REASON',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 2*SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            color: _expandReason ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                        ),
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cancelReasonModel!.data!.reasons!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RadioListTile(
                              value: index,
                              groupValue: selectedIndex,
                              onChanged: (val){
                                setState(() {
                                  selectedIndex = val;
                                });
                              },
                              title: Text(
                                '${cancelReasonModel!.data!.reasons![index].reason}',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    fontSize: 2*SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.start,
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              selectedTileColor: Colors.grey[400],
                              activeColor: Color(0xffcd3a62),
                            );
                          },
                        ),
                      ],
                    ),
                    if(cancelReasonModel!.data!.isPopupRequired!)
                      ExpansionTile(
                        onExpansionChanged: (value){
                          setState(() {
                            _expandRefund = !_expandRefund;
                          });
                        },
                          title: Text(
                            'SELECT A REFUND MODE',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 2*SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w600,
                                color: _expandRefund ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                            ),
                          ),
                        children: [
                          CheckboxListTile(
                            value: _credits,
                            onChanged: (bool? value){
                              setState(() {
                                _credits = value!;
                                _online = false;
                              });
                            },
                            title: Text(
                                'Credits'
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Color(0xffcd3a62),
                            checkColor: Colors.white,
                          ),
                          CheckboxListTile(
                            value: _online,
                            onChanged: (bool? value){
                              setState(() {
                                _online = value!;
                                _credits = false;
                              });
                            },
                            title: Text(
                                'Bank Account'
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Color(0xffcd3a62),
                            checkColor: Colors.white,
                          ),
                          if(_online)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Text(
                                  "You’ll receive an SMS/email for your bank details",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10
                                ),
                              ),
                            )
                        ],
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: cancelReasonModel!.data!.isPopupRequired! ?
                          (selectedIndex != -1 && (_credits || _online)) ? Color(0xffcd3a62) : Colors.pink[200] :
                          selectedIndex != -1 ? Color(0xffcd3a62) : Colors.pink[200],
                          padding: EdgeInsets.symmetric(
                              horizontal: 20*SizeConfig.widthMultiplier
                          )
                      ),
                      onPressed: () {
                        if(cancelReasonModel!.data!.isPopupRequired!){
                          if(selectedIndex != -1 && (_credits || _online)){
                            if(actionType == 'CANCEL'){
                              //log(cancelReturnReasonModel!.data![selectedIndex].reasonId!.toString());
                              cancelItemInitState(
                                  orderItemId,
                                  sku,
                                  cancelReasonModel!.data!.reasons![selectedIndex].reasonId!,
                                  _credits ? "CREDIT" : "ONLINE"
                              );
                              Navigator.pop(context);
                            }
                            else if(actionType == 'RETURN'){
                              returnInitState(orderItemId,
                                  sku,
                                  cancelReasonModel!.data!.reasons![selectedIndex].reasonId!,
                                  _credits ? "CREDIT" : "ONLINE"
                              );
                              Navigator.pop(context);
                            }
                            else if(actionType == 'EXCHANGE'){
                              Navigator.pop(context);
                              sizeExchangeItemInitState(orderItemId);
                            }
                          }
                          else {
                            null;
                          }
                        }
                        else{
                          if(selectedIndex != -1){
                            if(actionType == 'CANCEL'){
                              cancelItemInitState(
                                  orderItemId,
                                  sku,
                                  cancelReasonModel!.data!.reasons![selectedIndex].reasonId!,
                                  "CREDIT"
                              );
                              Navigator.pop(context);
                            }
                            else if(actionType == 'RETURN'){
                              returnInitState(orderItemId,
                                  sku,
                                  cancelReasonModel!.data!.reasons![selectedIndex].reasonId!,
                                  "CREDIT"
                              );
                              Navigator.pop(context);
                            }
                            else if(actionType == 'EXCHANGE'){
                              Navigator.pop(context);
                              sizeExchangeItemInitState(orderItemId);
                            }
                          }
                          else{
                            null;
                          }
                        }
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      if(value!=null){
      }
    });
  }



  Future _enterSize(BuildContext ctx) async{
    await showModalBottomSheet(
      constraints: BoxConstraints(
          maxHeight: SizeConfig.screenHeight/5
      ),
      context: ctx,
      builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExchangeAvailableSizes(
                sizeExchangeModel!
                    .data!.skuResponse, (value) {
              if (value != null) {
                if (sizeExchangeModel!.data!
                    .skuResponse![value].inventory! >
                    0) {
                  exchangeItemInitState(
                      widget.orderItem!.orderItemId!, sizeExchangeModel!.data!
                      .skuResponse![value].sku!,
                      cancelReasonModel!.data!.reasons![selectedIndex].reasonId!);
                }
                else {
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
              }
            }),
          );
      }
    ).then((value) {
      if(value!=null){
        callBackFunction(value);
      }
    });
  }
}
