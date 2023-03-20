import 'package:ouat/BaseBloc/base_event.dart';

class CheckOutEvent extends BaseEvent{
  CheckOutEvent([List props = const []]) : super(props);
}

class LoadEvent extends CheckOutEvent {
  String promoCode;
  LoadEvent(this.promoCode) : super([promoCode]);
}

class LoadingEvent extends CheckOutEvent{
  int address_id;
  String promo_code;
  List applied_credits;

  LoadingEvent(this.address_id, this.promo_code, this.applied_credits):
        super([address_id, promo_code, applied_credits]);
}

class PincodeEvent extends CheckOutEvent {
  String pincode;
  PincodeEvent(this.pincode):super([pincode]);
}

class GuestEvent extends CheckOutEvent {
  String mobile;
  String email;
  GuestEvent(this.mobile, this.email):super([mobile, email]);
}

class PlacingEvent extends CheckOutEvent{
  String payment_method;

  PlacingEvent(this.payment_method):
        super([payment_method]);
}

class CreateRazorpayCustomerEvent extends CheckOutEvent {
  String name;
  String mobile;
  String email;
  CreateRazorpayCustomerEvent(this.name, this.mobile, this.email):super([name, mobile, email]);
}