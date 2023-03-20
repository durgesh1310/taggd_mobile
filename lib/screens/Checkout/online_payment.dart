/*import 'package:flutter/material.dart';
import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';
import 'package:ouat/data/models/placeOrderModel.dart';
import 'package:ouat/screens/OrderConfirmation/order_confirmation_screen.dart';
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


class OnlinePayment extends StatefulWidget {
  const OnlinePayment({Key? key}) : super(key: key);

  @override
  _OnlinePaymentState createState() => _OnlinePaymentState();
}

class _OnlinePaymentState extends State<OnlinePayment> {
  bool _expandCard = false;
  bool _expandUpi = false;
  late Razorpay _razorpay;
  late PaymentBloc paymentBloc = PaymentBloc(SearchInitState());
  PlaceOrderModel? placeOrderModel = PlaceOrderModel();
  final TextEditingController card_name_controller = new TextEditingController();
  final TextEditingController card_number_controller = new TextEditingController();
  final TextEditingController expiry_date_controller = new TextEditingController();
  final TextEditingController cvv_controller = new TextEditingController();


  @override
  void initState() {
    _razorpay = Razorpay();
    //_razorpay.initilizeSDK(key);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //_razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.orderId);
    print(response.signature);
    print(response.paymentId);
    //StatusInitState(placeOrderModel!.data!.order_id!, "PS", response.paymentId!, "dyjf", "signature");
    //Navigator.pushNamed(context, OrderConfirmationScreen.ROUTE_NAME, arguments: {
    //  "order_id": placeOrderModel!.data!.order_id
    //});
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  /*void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }*/


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/
