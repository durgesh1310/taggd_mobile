import 'package:ouat/BaseBloc/base_event.dart';

class PaymentEvent extends BaseEvent{
  PaymentEvent([List props = const []]) : super(props);
}

class LoadEvent extends PaymentEvent {
  int order_id;
      String payment_status;
  String payment_id;
      String razorpay_order_id;
  String signature;

  LoadEvent(
      this.order_id,
      this.payment_status,
      this.payment_id,
      this.razorpay_order_id,
      this.signature
      ):
        super([
          order_id,
        payment_status,
        payment_id,
        razorpay_order_id,
        signature
      ]);
}

class LoadingEvent extends PaymentEvent{
  String payment_method;

  LoadingEvent(this.payment_method):
        super([payment_method]);
}

class PincodeEvent extends PaymentEvent {
  String pincode;
  PincodeEvent(this.pincode):super([pincode]);
}
