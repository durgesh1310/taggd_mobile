import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ouat/data/models/NetBankingModel.dart';
import 'package:ouat/data/models/checkOutModel.dart';
import 'package:ouat/data/models/placeOrderModel.dart';
import 'package:ouat/screens/OrderConfirmation/order_confirmation_screen.dart';
import 'package:ouat/utility/thirdParty/appsFlyer.dart';
import 'package:ouat/utility/thirdParty/netcoreEvents.dart';
import 'package:ouat/widgets/order_summary.dart';
import '../../size_config.dart';
import 'package:ouat/utility/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ouat/BaseBloc/base_bloc_builder.dart';
import 'package:ouat/BaseBloc/base_bloc_listener.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/widgets/general_dialog.dart';
import './payment_state.dart';
import './payment_bloc.dart';
import './payment_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';
import 'banks_screen.dart';
import 'details_formatter.dart';

enum PaymentMethods { card, upi, nb, wallet, vas }


class PaymentScreen extends StatefulWidget {
  CheckOutModel checkOutModel;
  var callBackFunction;
  PaymentScreen(this.checkOutModel, this.callBackFunction);
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  late PaymentBloc paymentBloc = PaymentBloc(SearchInitState());
  PlaceOrderModel? placeOrderModel = PlaceOrderModel();
  String selectedPaymentType = 'CARD';
  PaymentMethods selectedMethod = PaymentMethods.card;
  String? cardNetwork;
  bool showUpiApps = false;
  String? optionsType;
  Map<String, dynamic> options = new Map();
  bool _cod = false;
  bool _online = false;
  bool _expandCard = false;
  bool _expandWallet = false;
  bool _expandUpi = false;
  bool _expandPaylater = false;
  bool _expandBank = false;
  bool isSavingCard = false;
  var mobile, email;
  Map<dynamic, dynamic>? paymentMethods;
  List<NetBankingModel> netBankingList = [];
  List<WalletModel> walletsList = [];
  late Razorpay _razorpay;
  Map<String, dynamic>? commonPaymentOptions;
  late SharedPreferences userData;
  late String payment_way;
  late String payment_method;
  bool _isCredits = false;
  double totalSavings = 0.0;
  int selectedIndex = 0;
  final _cardKey = GlobalKey<FormState>();
  List<String>? walletLogo;
  List<String>? bankLogoUrl;
  final TextEditingController card_name_controller = new TextEditingController();
  final TextEditingController card_number_controller = new TextEditingController();
  final TextEditingController expiry_date_controller = new TextEditingController();
  final TextEditingController cvv_controller = new TextEditingController();
  final TextEditingController upi_controller = new TextEditingController();
  final TextEditingController saved_cvv_controller = new TextEditingController();
  var placeOrderPayload;
  late int selectedRadioTile;
  var expandCvv;


  @override
  void initState() {
    selectedRadioTile = -1;
    if(widget.checkOutModel.data!.pgCustomerData != null){
      expandCvv = new List.filled(widget.checkOutModel.data!.pgCustomerData!.savedCards!.count!, false, growable: false);
    }
    if(
    (widget.checkOutModel.data!.pricingSummary!.totalPlatformDiscount != null ||
        widget.checkOutModel.data!.pricingSummary!.totalPromoDiscount != null )
    ){
      if (widget.checkOutModel.data!.pricingSummary!.totalPlatformDiscount != 0.0 ||
          widget.checkOutModel.data!.pricingSummary!.totalPromoDiscount != 0.0){
        totalSavings = widget.checkOutModel.data!.pricingSummary!.totalPlatformDiscount! +
            (widget.checkOutModel.data!.pricingSummary!.totalPromoDiscount ?? 0.0);
      }
      else if(
      widget.checkOutModel.data!.pricingSummary!.totalPromoDiscount != 0.0
      ){
        totalSavings = widget.checkOutModel.data!.pricingSummary!.totalPromoDiscount!;
      }
      else{
        totalSavings = widget.checkOutModel.data!.pricingSummary!.totalPlatformDiscount!;
      }
    }
    _razorpay = Razorpay();
    _razorpay.initilizeSDK("${Constants.razorpay_key}");
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initSharedPref();
    onlinePayment();
  }

  void initSharedPref() async{
    userData = await SharedPreferences.getInstance();
    mobile = (userData.getString('mobile') ?? '');
    email = (userData.getString('email') ?? '');
  }

  void onlinePayment() async{
    _razorpay.getPaymentMethods().then((value) {
      paymentMethods = value;
      configurePaymentWallets();
      configureNetbanking();
    }).onError((error, stackTrace) {
      print('Error Fetching payment methods: $error');
    });
  }

  configureNetbanking() {
    netBankingList = [];
    final nbDict = paymentMethods?['netbanking'];
    nbDict.entries.forEach(
          (element) async {
        String logo = await _razorpay.getBankLogoUrl(element.key);
        netBankingList.add(NetBankingModel(bankKey: element.key, bankName: element.value, bankLogoUrl: logo),
        );
      },
    );
  }

  configurePaymentWallets() {
    walletsList = [];
    walletLogo = [];
    final walletsDict = paymentMethods?['wallet'];
    walletsDict.entries.forEach(
          (element) async {
        if (element.value == true) {
          walletsList.add(
            WalletModel(walletName: element.key),
          );
          String logo = await _razorpay.getWalletLogoUrl('${element.key}');
          walletLogo!.add(logo);
        }
      },
    );
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
      expandCvv = List.filled(widget.checkOutModel.data!.pgCustomerData!.savedCards!.count!, false, growable: false);
      expandCvv[val] = true;
    });
    FocusScope.of(context).unfocus();
  }

  /*String? bankNames(String bankKey){
    return netBankingList.firstWhere((element) {
      return element.bankKey == bankKey;
    }).bankName;
  }*/

  getInitState(String payment_method) async {
    paymentBloc.add(LoadingEvent("$payment_method"));
    setState(() {
      payment_way = payment_method;
    });
  }



  StatusInitState(int order_id,
      String payment_status,
      String payment_id,
      String razorpay_order_id,
      String signature) async{
    paymentBloc.add(LoadEvent(order_id, payment_status, payment_id, razorpay_order_id, signature));
  }



  @override
  void dispose() {
    _razorpay.clear();
    card_name_controller.dispose();
    card_number_controller.dispose();
    expiry_date_controller.dispose();
    cvv_controller.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(Map response)  {
    log(response.toString());
    if(Platform.isIOS){
      StatusInitState(placeOrderModel!.data!.order_id!, "PS", response['razorpay_payment_id'], response['razorpay_order_id'], response['razorpay_signature']);
    }
    else{
      StatusInitState(placeOrderModel!.data!.order_id!, "PS", response['data']['razorpay_payment_id'], response['data']['razorpay_order_id'], response['data']['razorpay_signature']);
    }
    //log(response['data']['razorpay_payment_id']);
    AppsFlyer.paymentSuccessTrack(widget.checkOutModel.data!.pricingSummary!.totalPrice!,
        widget.checkOutModel.data!.pricingSummary!.totalDeliveryCharges!,
        widget.checkOutModel.data!.pricingSummary!.totalCreditValue!,
        widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!,
        _cod ? widget.checkOutModel.data!.paymentMethod!.contains('OWP') ? "OWP" : "ONLINE" : "COD");
    NetcoreEvents.paymentSuccessTrack(widget.checkOutModel.data!.pricingSummary!.totalPrice!,
        widget.checkOutModel.data!.pricingSummary!.totalDeliveryCharges!,
        widget.checkOutModel.data!.pricingSummary!.totalCreditValue!,
        widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!,
        _cod ? widget.checkOutModel.data!.paymentMethod!.contains('OWP') ? "OWP" : "ONLINE" : "COD");
    Navigator.pushNamed(context, OrderConfirmationScreen.ROUTE_NAME, arguments: {
      "order_id": placeOrderModel!.data!.order_id
    });
  }

  void _handlePaymentError(Map response) {
    log(response.toString());
    StatusInitState(placeOrderModel!.data!.order_id!, "PF", '', '', '');
    AppsFlyer.paymentFailedTrack(widget.checkOutModel.data!.pricingSummary!.totalPrice!,
        widget.checkOutModel.data!.pricingSummary!.totalDeliveryCharges!,
        widget.checkOutModel.data!.pricingSummary!.totalCreditValue!,
        widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!,
        _cod ? widget.checkOutModel.data!.paymentMethod!.contains('OWP') ? "OWP" : "ONLINE" : "COD");
    NetcoreEvents.paymentFailedTrack(widget.checkOutModel.data!.pricingSummary!.totalPrice!,
        widget.checkOutModel.data!.pricingSummary!.totalDeliveryCharges!,
        widget.checkOutModel.data!.pricingSummary!.totalCreditValue!,
        widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!,
        _cod ? widget.checkOutModel.data!.paymentMethod!.contains('OWP') ? "OWP" : "ONLINE" : "COD");
    final snackBar = SnackBar(
      backgroundColor: Color(0xffcd3a62),
      duration: Duration(seconds: 3),
      content: Text(
        'Payment Failed',
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
    widget.callBackFunction([]);
    options.clear();
  }

  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return BlocProvider(
      create: (context) => paymentBloc,
      child: BaseBlocListener(
          bloc: paymentBloc,
          listener: (context, state) {

            if (state is CompletedState) {
              placeOrderModel = state.placeOrderModel;
              NetcoreEvents.placeOrderTrack(
                  widget.checkOutModel.data!.pricingSummary!.totalPrice!,
                  widget.checkOutModel.data!.pricingSummary!.totalDeliveryCharges!,
                  widget.checkOutModel.data!.pricingSummary!.totalCreditValue!,
                  widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!,
                  _cod ? widget.checkOutModel.data!.paymentMethod!.contains('OWP') ? "OWP" : "ONLINE" : "COD");
              AppsFlyer.placeOrderTrack(
                  widget.checkOutModel.data!.pricingSummary!.totalPrice!,
                  widget.checkOutModel.data!.pricingSummary!.totalDeliveryCharges!,
                  widget.checkOutModel.data!.pricingSummary!.totalCreditValue!,
                  widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!,
                  _cod ? widget.checkOutModel.data!.paymentMethod!.contains('OWP') ? "OWP" : "ONLINE" : "COD");
              if(payment_way == "COD" || payment_way == "OWP"){
                Fluttertoast.showToast(msg: state.placeOrderModel!.message![0].msgText!);
                Navigator.pushNamed(context, OrderConfirmationScreen.ROUTE_NAME, arguments: {
                  "order_id": state.placeOrderModel!.data!.order_id
                });
              }
              else{

                if(optionsType == 'CARD'){
                  if(isSavingCard){
                    options = {
                      'key': Constants.razorpay_key,
                      'amount': widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100,
                      "order_id": '${placeOrderModel!.data!.third_party_order_id}',
                      "card[cvv]": CardInfoModel.cvv,
                      "card[expiry_month]": CardInfoModel.expiryMonth,
                      "card[expiry_year]": CardInfoModel.expiryYear,
                      "card[name]": CardInfoModel.cardHolderName,
                      "card[number]": CardInfoModel.cardNumber,
                      "contact": '$mobile',
                      "currency": "INR",
                      'email': '$email',
                      "method": "card",
                      "customer_id": "${widget.checkOutModel.data!.pgCustomerData!.pgCustomerId}",
                      "save" : "1"
                    };
                  }
                  else{
                    options = {
                      'key': Constants.razorpay_key,
                      'amount': widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100,
                      "order_id": '${placeOrderModel!.data!.third_party_order_id}',
                      "card[cvv]": CardInfoModel.cvv,
                      "card[expiry_month]": CardInfoModel.expiryMonth,
                      "card[expiry_year]": CardInfoModel.expiryYear,
                      "card[name]": CardInfoModel.cardHolderName,
                      "card[number]": CardInfoModel.cardNumber,
                      "contact": '$mobile',
                      "currency": "INR",
                      'email': '$email',
                      "method": "card",
                    };
                  }
                }
                else if(optionsType == 'SAVED CARD'){
                  options.putIfAbsent('key', () => Constants.razorpay_key);
                  options.putIfAbsent('order_id', () => '${placeOrderModel!.data!.third_party_order_id}');
                  options.putIfAbsent('customer_id', () => "${widget.checkOutModel.data!.pgCustomerData!.pgCustomerId}");
                  options.putIfAbsent('method', () => 'card');
                  options.putIfAbsent('card[cvv]', () => CardInfoModel.cvv);
                  options.putIfAbsent('consent_to_save_card', () => "1");
                }
                else if(optionsType == 'NET BANKING'){
                  options.putIfAbsent('key', () => Constants.razorpay_key);
                  options.putIfAbsent('amount', () => widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100);
                  options.putIfAbsent('order_id', () => '${placeOrderModel!.data!.third_party_order_id}');
                  options.putIfAbsent('currency', () => 'INR');
                  options.putIfAbsent('email', () => '$email');
                  options.putIfAbsent('contact', () => '$mobile');
                  options.putIfAbsent('method', () => 'netbanking');
                }
                else if(optionsType == 'WALLET'){
                  options.putIfAbsent('key', () => Constants.razorpay_key);
                  options.putIfAbsent('amount', () => widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100);
                  options.putIfAbsent('order_id', () => '${placeOrderModel!.data!.third_party_order_id}');
                  options.putIfAbsent('currency', () => 'INR');
                  options.putIfAbsent('email', () => '$email');
                  options.putIfAbsent('contact', () => '$mobile');
                  options.putIfAbsent('method', () => 'wallet');
                }
                else if(optionsType == 'UPI'){
                  options = {
                    'key': Constants.razorpay_key,
                    'amount': widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100,
                    "order_id": '${placeOrderModel!.data!.third_party_order_id}',
                    'currency': 'INR',
                    'email': '${email}',
                    'contact': '${mobile}',
                    'method': 'upi',
                    'vpa': upi_controller.text.toString(),
                    '_[flow]': 'collect',
                  };
                }
                else if(optionsType == 'SIMPL'){
                  options = {
                    "key": Constants.razorpay_key,
                    "amount": widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100,
                    "currency": "INR",
                    "email": '${email}',
                    "contact": '${mobile}',
                    "method": "paylater",
                    "provider": "getsimpl",
                    "order_id": '${placeOrderModel!.data!.third_party_order_id}'
                  };
                }
                else if(optionsType == 'ICICI'){
                  options = {
                    "key": Constants.razorpay_key,
                    "amount": widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100,
                    "currency": "INR",
                    "email": '${email}',
                    "contact": '${mobile}',
                    "method": "paylater",
                    "provider": "icic",
                    "order_id": '${placeOrderModel!.data!.third_party_order_id}'
                  };
                }
                else if(optionsType == 'LazyPay'){
                  options = {
                    "key": Constants.razorpay_key,
                    "amount": widget.checkOutModel.data!.pricingSummary!.totalOrderPayable!.toInt() * 100,
                    "currency": "INR",
                    "email": '${email}',
                    "contact": '${mobile}',
                    "method": "paylater",
                    "provider": "lazypay",
                    "order_id": '${placeOrderModel!.data!.third_party_order_id}'
                  };
                }

                commonPaymentOptions = {};
                log(options.toString());
                try{
                  _razorpay.submit(options);
                }
                catch (exc){
                  debugPrint(exc.toString());
                }
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
                },
              );
            }

          },
          child: BaseBlocBuilder(
              bloc: paymentBloc,
              condition: (oldState, currentState) {
                return !(BaseBlocBuilder.isBaseState(currentState));
              },
              builder: (BuildContext context, BaseState state) {

                if (true) {
                  return Scaffold(
                    appBar: AppBar(
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
                      centerTitle: false,
                      title: Text(
                        "Payment",
                        style: TextStyle(
                            fontFamily: 'RecklessNeue',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                      automaticallyImplyLeading: false,
                      actions: [
                        Center(
                          child: Text(
                            'Step 2 of 2',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ShowOrderSummary(
                                      subtotal: widget.checkOutModel.data!.pricingSummary!.totalPrice,
                                      platformDiscount: widget.checkOutModel.data!.pricingSummary!.totalPlatformDiscount,
                                      promoDiscount: widget.checkOutModel.data!.pricingSummary!.totalPromoDiscount,
                                      promoCode: widget.checkOutModel.data!.pricingSummary!.promoCode,
                                      credits: widget.checkOutModel.data!.pricingSummary!.totalCreditValue,
                                      creditsType: widget.checkOutModel.data!.credits!.length == 0 ?
                                          "" : widget.checkOutModel.data!.credits!.first.creditName,
                                      deliveryCharges: widget.checkOutModel.data!.pricingSummary!.totalDeliveryCharges,
                                      shippingMessage: null,
                                      totalSavings: totalSavings,
                                      orderTotal: widget.checkOutModel.data!.pricingSummary!.totalOrderPayable,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                            child: Text(
                              'Choose Your Payment Method',
                              style: TextStyle(
                                  fontSize: textScale >1 ? 2.5*SizeConfig.textMultiplier : 2.8*SizeConfig.textMultiplier,
                                  fontFamily: 'RecklessNeue',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          if(widget.checkOutModel.data!.credits!.length > 0 && widget.checkOutModel.data!.credits!.first.amount! > 0)
                            Column(
                              children: widget.checkOutModel.data!.credits!.map(
                                    (e) => Card(
                                  elevation: 2,
                                  shadowColor: Colors.black,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4*SizeConfig.heightMultiplier)
                                        )
                                    ),
                                    leading: Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.black,
                                    ),
                                    title: Text(
                                      "${e.creditName}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'RecklessNeue',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2*SizeConfig.textMultiplier
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${e.amount!.round()}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Inter',
                                          fontSize: 1.5*SizeConfig.textMultiplier
                                      ),
                                    ),
                                    trailing:  Switch(
                                      value: _isCredits,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _isCredits = value;
                                        });
                                        if(value == true){
                                          widget.callBackFunction(["${e.creditName}"]);
                                        }
                                        else{
                                          widget.callBackFunction([]);
                                        }
                                      },
                                      activeTrackColor: Color(0xffff9d9d),
                                      activeColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                          Center(
                            child: Column(
                              children: [
                                widget.checkOutModel.data!.paymentMethod!.contains('OWP') ?
                                CheckboxListTile(
                                  value: _cod,
                                  onChanged: (bool? value){
                                    setState(() {
                                      _cod = value!;
                                      _online = false;
                                    });
                                  },
                                  secondary: Container(
                                    width: SizeConfig.widthMultiplier * 10,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.scaleDown,
                                      imageUrl: 'https://taggd.gumlet.io/logo/cod-icon.png',
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                                          )),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                  title: Text(
                                    'Order Without Payment',
                                    style: TextStyle(
                                      fontFamily: 'RecklessNeue',
                                    ),
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  activeColor: Color(0xffcd3a62),
                                  checkColor: Colors.white,
                                ):
                                Column(
                                  children: [
                                    Divider(),
                                    if(widget.checkOutModel.data!.paymentMethod!.contains('ONLINE') || widget.checkOutModel.data!.paymentMethod!.contains('ALL'))
                                    /*if(widget.checkOutModel.data!.pgCustomerData != null)
                                        ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: widget.checkOutModel.data!.pgCustomerData!.savedCards!.count,
                                            itemBuilder: (context, index){
                                              return Column(
                                                children: [
                                                  RadioListTile(
                                                    value: index,
                                                    groupValue: selectedRadioTile,
                                                    title: RichText(
                                                      text: TextSpan(
                                                          text: '${widget.checkOutModel.data!.pgCustomerData!.savedCards!.items![index].paymentCard!.issuer!} ',
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: Colors.black,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: '${widget.checkOutModel.data!.pgCustomerData!.savedCards!.items![index].paymentCard!.type} ',
                                                            ),
                                                            TextSpan(
                                                              text: '${widget.checkOutModel.data!.pgCustomerData!.savedCards!.items![index].paymentCard!.entity} ',
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                    //Text("${widget.checkOutModel.data!.pgCustomerData!.savedCards!.items![index].paymentCard!.name}"),
                                                    subtitle: Text("XXXX XXXX XXXX ${widget.checkOutModel.data!.pgCustomerData!.savedCards!.items![index].paymentCard!.last4}"),
                                                    onChanged: (val) {
                                                      setSelectedRadioTile(int. parse(val.toString()));
                                                    },
                                                    activeColor: Colors.black,
                                                    //secondary: ,
                                                    selected: true,
                                                  ),
                                                  AnimatedContainer(
                                                      duration: const Duration(seconds: 1),
                                                      height: expandCvv[index]
                                                          ?  70
                                                          : 0,
                                                      curve: Curves.fastOutSlowIn,
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: TextFormField(
                                                                controller: saved_cvv_controller,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                  LengthLimitingTextInputFormatter(3),
                                                                ],
                                                                obscureText: true,
                                                                obscuringCharacter: '*',
                                                                cursorColor: Color(0xffcd3a62),
                                                                textAlign: TextAlign.center,
                                                                decoration: InputDecoration(
                                                                    labelStyle: TextStyle(
                                                                        color: Color(0xff4D4D4D),
                                                                        fontWeight: FontWeight.w500,
                                                                        fontFamily: "Inter"
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(color: Colors.black)
                                                                    ),
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(color: Colors.grey)
                                                                    ),
                                                                    labelText: "*CVV",
                                                                    hintText: "***"
                                                                ),
                                                                keyboardType: TextInputType.number,
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                              child: placeOrderButton('SAVED CARD', widget.checkOutModel.data!.pgCustomerData!.savedCards!.items![index].id!)
                                                          )
                                                        ],
                                                      )
                                                  )
                                                ],
                                              );
                                            }
                                        ),*/
                                      ExpansionTile(
                                        onExpansionChanged: (value){
                                          setState(() {
                                            _expandCard = !_expandCard;
                                          });
                                          if(_expandCard){
                                            setState(() {
                                              selectedPaymentType = 'CARD';
                                              selectedMethod = PaymentMethods.card;
                                            });
                                          }
                                        },
                                        leading: SvgPicture.asset(
                                          _expandCard ? 'assets/icons/cardActive.svg' : 'assets/icons/card.svg',
                                          height: 30,
                                        ),
                                        title: Text(
                                          'Credit/Debit Card',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 2*SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w600,
                                              color: _expandCard ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                                          ),
                                        ),
                                        children: <Widget>[
                                          Text(
                                            'Add New Card',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 2*SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Form(
                                            key: _cardKey,
                                            child: Padding(
                                              padding:  EdgeInsets.symmetric(vertical: 8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      onChanged: (String value) async{
                                                        var cardNetworkType = await _razorpay.getCardsNetwork(value);
                                                        log(cardNetworkType);
                                                            if(cardNetworkType == 'visa'){
                                                              setState(() {
                                                                this.cardNetwork = 'https://taggd.gumlet.io/logo/bank-logo/icon-payment-visa.png';
                                                              });
                                                            }
                                                            else if(cardNetworkType == 'maestro'){
                                                              setState(() {
                                                                this.cardNetwork = 'https://taggd.gumlet.io/logo/bank-logo/icon-payment-maestro.png';
                                                              });
                                                            }
                                                            else if(cardNetworkType == 'rupay'){
                                                              setState(() {
                                                                this.cardNetwork = 'https://taggd.gumlet.io/logo/bank-logo/icon-payment-rupay.png';
                                                              });
                                                            }
                                                            else if(cardNetworkType == 'mastercard'){
                                                              setState(() {
                                                                this.cardNetwork = 'https://taggd.gumlet.io/logo/bank-logo/icon-payment-master-card.png';
                                                              });
                                                            }
                                                            else if(cardNetworkType == 'amex'){
                                                              setState(() {
                                                                this.cardNetwork = 'https://taggd.gumlet.io/logo/bank-logo/icon-payment-amex.png';
                                                              });
                                                            }
                                                            else{
                                                              setState(() {
                                                                this.cardNetwork = 'unknown';
                                                              });
                                                            }
                                                      },
                                                      controller: card_number_controller,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(19),
                                                        FilteringTextInputFormatter.digitsOnly,
                                                        CardNumberFormatter(),
                                                      ],
                                                      cursorColor: Color(0xffcd3a62),
                                                      decoration: InputDecoration(
                                                        labelStyle: TextStyle(
                                                            color: Color(0xff4D4D4D),
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: "Inter"
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black)
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.grey)
                                                        ),
                                                        labelText: "*Card Number",
                                                        hintText: 'XXXX XXXX XXXX XXXX',
                                                        suffixIcon: cardNetwork != "unknown" ?
                                                        CachedNetworkImage(
                                                          fit: BoxFit.scaleDown,
                                                          imageUrl: '${cardNetwork}',
                                                          placeholder: (context, url) => Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 1,
                                                              valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                                                            ),
                                                          ),
                                                          errorWidget: (context, url, error) => Container(width: 2,),
                                                        ) :
                                                        Container(width: 2),
                                                      ),
                                                      keyboardType: TextInputType.number,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      controller: card_name_controller,
                                                      cursorColor: Color(0xffcd3a62),
                                                      decoration: InputDecoration(
                                                        labelStyle: TextStyle(
                                                            color: Color(0xff4D4D4D),
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: "Inter"
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black)
                                                        ),
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.grey)
                                                        ),
                                                        labelText: "*Card Holder Name",
                                                      ),
                                                      keyboardType: TextInputType.name,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextFormField(
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.digitsOnly,
                                                              LengthLimitingTextInputFormatter(4),
                                                              CardMonthInputFormatter()
                                                            ],
                                                            controller: expiry_date_controller,
                                                            cursorColor: Color(0xffcd3a62),
                                                            decoration: InputDecoration(
                                                              labelStyle: TextStyle(
                                                                  color: Color(0xff4D4D4D),
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "Inter"
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.black)
                                                              ),
                                                              border: OutlineInputBorder(
                                                                  borderSide: BorderSide(color: Colors.grey)
                                                              ),
                                                              labelText: "*Valid Thru",
                                                              hintText: 'MM/YY',
                                                            ),
                                                            keyboardType: TextInputType.number,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextFormField(
                                                            controller: cvv_controller,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.digitsOnly,
                                                              LengthLimitingTextInputFormatter(3),
                                                            ],
                                                            obscureText: true,
                                                            obscuringCharacter: '*',
                                                            cursorColor: Color(0xffcd3a62),
                                                            textAlign: TextAlign.center,
                                                            decoration: InputDecoration(
                                                                labelStyle: TextStyle(
                                                                    color: Color(0xff4D4D4D),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: "Inter"
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.black)
                                                                ),
                                                                border: OutlineInputBorder(
                                                                    borderSide: BorderSide(color: Colors.grey)
                                                                ),
                                                                labelText: "*CVV",
                                                                hintText: "***"
                                                            ),
                                                            keyboardType: TextInputType.number,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  CheckboxListTile(
                                                    value: isSavingCard,
                                                    onChanged: (bool? value){
                                                      setState(() {
                                                        isSavingCard = value!;
                                                      });
                                                    },
                                                    title: Text(
                                                      'Save Card Securely For Future Purchases',
                                                      style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 2*SizeConfig.textMultiplier,
                                                          fontWeight: FontWeight.w600,
                                                          color: isSavingCard ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                                                      ),
                                                    ),
                                                    controlAffinity: ListTileControlAffinity.trailing,
                                                    activeColor: Color(0xffcd3a62),
                                                    checkColor: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          placeOrderButton('CARD', "")
                                        ],
                                      ),
                                    Divider(),
                                    ExpansionTile(
                                      onExpansionChanged: (value){
                                        setState(() {
                                          _expandWallet = !_expandWallet;
                                        });
                                        if(_expandWallet){
                                          setState(() {
                                            selectedPaymentType = 'WALLET';
                                            selectedMethod = PaymentMethods.wallet;
                                          });
                                        }
                                      },
                                      leading: SvgPicture.asset(
                                        _expandWallet ? 'assets/icons/walletActive.svg' : 'assets/icons/wallet.svg',
                                        height: 30,
                                      ),
                                      title: Text(
                                        'Wallets',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            color: _expandWallet ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                                        ),
                                      ),
                                      children: <Widget>[
                                        Container(
                                            child: MasonryGridView.count(
                                                crossAxisCount: 4,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 5,
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemCount: walletsList.length,
                                                itemBuilder: (context, item){
                                                  return walletsList.isNotEmpty ?
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        optionsType = 'WALLET';
                                                        options.putIfAbsent('wallet', () => walletsList[item].walletName);
                                                      });
                                                      getInitState("ONLINE");
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: CachedNetworkImage(
                                                        height: 20,
                                                        width: 20,
                                                        fit: BoxFit.scaleDown,
                                                        imageUrl: '${walletLogo![item]}',
                                                        placeholder: (context, url) => Center(
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 1,
                                                              valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                                                            )),
                                                        errorWidget: (context, url, error) => Container(),
                                                      ),
                                                    ),
                                                  ) :
                                                  Container();
                                                }
                                            )
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    ExpansionTile(
                                      onExpansionChanged: (value){
                                        setState(() {
                                          _expandBank = !_expandBank;
                                        });
                                        log(bankLogoUrl.toString());
                                        if(_expandBank){
                                          setState(() {
                                            selectedPaymentType = 'NET BANKING';
                                            selectedMethod = PaymentMethods.nb;
                                          });
                                        }
                                      },
                                      leading: SvgPicture.asset(
                                        _expandBank ? 'assets/icons/bankActive.svg' : 'assets/icons/bank.svg',
                                        height: 30,
                                      ),
                                      title: Text(
                                        'NetBanking',
                                        style: TextStyle(
                                          fontSize: 2*SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                            color: _expandBank ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                                        ),
                                      ),
                                      children: <Widget>[
                                        MasonryGridView.count(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: 4,
                                            itemBuilder: (context, item){
                                              return netBankingList.isNotEmpty ?
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    optionsType = 'NET BANKING';
                                                    options.putIfAbsent('bank', () => netBankingList[item].bankKey);
                                                  });
                                                  getInitState("ONLINE");
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 12*SizeConfig.heightMultiplier,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: CachedNetworkImage(
                                                          height: 30,
                                                          width: 30,
                                                          fit: BoxFit.scaleDown,
                                                          imageUrl: '${netBankingList[item].bankLogoUrl}',
                                                          placeholder: (context, url) => Center(
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 1,
                                                                valueColor: AlwaysStoppedAnimation(Color(0xffcd3a62)),
                                                              )),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${netBankingList[item].bankKey}",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ):
                                              Container();
                                            }
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xffcd3a62),
                                                  minimumSize: Size(
                                                      2*SizeConfig.screenWidth,
                                                      50
                                                  )
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(context, BankScreen.ROUTE_NAME,
                                                    arguments: {
                                                      "bank": netBankingList,
                                                      "callback": (bankName) {
                                                        if(bankName != null){
                                                          setState(() {
                                                            optionsType = 'NET BANKING';
                                                            options.putIfAbsent('bank', () => bankName);
                                                          });
                                                          getInitState("ONLINE");
                                                        }
                                                      }
                                                    });
                                              },
                                              child: Text('Other Banks'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    ExpansionTile(
                                      onExpansionChanged: (value){
                                        setState(() {
                                          _expandUpi = !_expandUpi;
                                          _expandPaylater = false;
                                          _expandBank = false;
                                        });
                                        if(_expandUpi){
                                          setState(() {
                                            selectedPaymentType = 'UPI';
                                            selectedMethod = PaymentMethods.upi;
                                          });
                                        }
                                      },
                                      leading: SvgPicture.asset(
                                        _expandUpi ? 'assets/icons/upiActive.svg' : 'assets/icons/upi.svg',
                                        height: 30,
                                      ),
                                      title: Text(
                                        'UPI',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            color: _expandUpi ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                                        ),
                                      ),
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: upi_controller,
                                            cursorColor: Color(0xffcd3a62),
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Color(0xff4D4D4D),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Inter"
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black)
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey)
                                              ),
                                              labelText: "UPI ID",
                                            ),
                                            keyboardType: TextInputType.emailAddress,
                                          ),
                                        ),
                                        SizedBox(height: 16.0),
                                        placeOrderButton('UPI', ""),
                                      ],
                                    ),
                                    Divider(),
                                    /*ExpansionTile(
                                      onExpansionChanged: (value){
                                        setState(() {
                                          _expandPaylater = !_expandPaylater;
                                        });
                                      },
                                      leading: SvgPicture.asset(
                                        _expandPaylater ? 'assets/icons/paylaterActive.svg' : 'assets/icons/paylater.svg',
                                        height: 30,
                                      ),
                                      title: Text(
                                        'Pay Later',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 2*SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            color: _expandPaylater ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                                        ),
                                      ),
                                      children: [
                                        Text(
                                          'Select an option',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 2*SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black
                                          ),
                                        ),
                                        ListTile(
                                          leading: Image.network('https://taggd.gumlet.io/logo/pay-leter-lazypay.png'),
                                          onTap: (){
                                            setState(() {
                                              optionsType = 'LazyPay';
                                            });
                                            getInitState("ONLINE");
                                          },
                                          title: Text(
                                            'LazyPay',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          leading: Image.network('https://taggd.gumlet.io/logo/pay-leter-getsimpl.png'),
                                          onTap: (){
                                            setState(() {
                                              optionsType = 'SIMPL';
                                            });
                                            getInitState("ONLINE");
                                          },
                                          title: Text(
                                            'Simpl',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          leading: Image.network('https://taggd.gumlet.io/logo/pay-leter-icici.png'),
                                          onTap: (){
                                            setState(() {
                                              optionsType = 'ICICI';
                                            });
                                            getInitState("ONLINE");
                                          },
                                          title: Text(
                                            'ICICI Bank PayLater',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(),*/
                                    widget.checkOutModel.data!.paymentMethod!.contains('COD') || widget.checkOutModel.data!.paymentMethod!.contains('ALL')?
                                    CheckboxListTile(
                                      value: _cod,
                                      onChanged: (bool? value){
                                        setState(() {
                                          _cod = value!;
                                          _online = false;
                                        });
                                      },
                                      title: Row(
                                        children: [
                                          SvgPicture.asset(
                                            _cod ? 'assets/icons/cashActive.svg' : 'assets/icons/cash.svg',
                                            height: 30,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            'Cash on Delivery',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 2*SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w600,
                                                color: _cod ? Color(0xffcd3a62) : Color(0xff4D4D4D)
                                            ),
                                          ),
                                        ],
                                      ),
                                      controlAffinity: ListTileControlAffinity.trailing,
                                      activeColor: Color(0xffcd3a62),
                                      checkColor: Colors.white,
                                    ) :
                                    Container(),
                                  ],
                                ),
                                if(_cod)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color(0xffcd3a62),
                                            minimumSize: Size(
                                                2*SizeConfig.screenWidth,
                                                50
                                            )
                                        ),
                                        onPressed: () {
                                          getInitState("COD");
                                        },
                                        child: Text('Pay ₹${widget.checkOutModel.data!.pricingSummary!.totalOrderPayable}'),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              })),
    );
  }

  Widget placeOrderButton(String type, String token){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Color(0xffcd3a62),
            minimumSize: Size(
                2*SizeConfig.screenWidth,
                50
            )
        ),
        onPressed: () async{
          FocusScope.of(context).unfocus();
          if(type == 'UPI'){
            if (upi_controller == null || upi_controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please Enter UPI ID'),
                ),
              );
              return;
            }
            FocusScope.of(context).unfocus();
          }
          else if(type == 'CARD'){
            var error = await CardInfoModel.validateCardFields(
                card_number_controller.text.toString(),
                card_name_controller.text.toString(),
                cvv_controller.text.toString(),
                expiry_date_controller.text.toString()
            );
            if (error != '') {
              print(error);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error)));
              return;
            }
            CardInfoModel.cvv = cvv_controller.text.toString();
            CardInfoModel.cardHolderName = card_name_controller.text.toString();
          }
          else if(type == 'SAVED CARD'){
            if (saved_cvv_controller.text.toString() == '') {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('CVV Cannot be Empty')));
              return;
            }
            if(saved_cvv_controller.text.toString() != ''){
              if (saved_cvv_controller.text.toString().length < 3 || saved_cvv_controller.text.toString().length > 4) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("CVV is invalid")));
                return;
              }
            }
            CardInfoModel.cvv = saved_cvv_controller.text.toString();
            options.putIfAbsent('token', () => '${token}');
          }
          setState(() {
            optionsType = type;
          });
          getInitState("ONLINE");
        },
        child: Text('Pay ₹${widget.checkOutModel.data!.pricingSummary!.totalOrderPayable}'),
      ),
    );
  }


}