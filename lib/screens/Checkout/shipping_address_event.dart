import 'package:ouat/BaseBloc/base_event.dart';

class ShippingAddressEvent extends BaseEvent{
  ShippingAddressEvent([List props = const []]) : super(props);
}


class ProgressEvent extends ShippingAddressEvent {
  String fullname;
  int pincode;
  String address;
  String landmark;
  String mobile;
  String city;
  String state;
  ProgressEvent(
      this.fullname,
      this.pincode,
      this.address,
      this.landmark,
      this.mobile,
      this.city,
      this.state
      ):
        super([
          fullname,
        pincode,
        address,
        landmark,
        mobile,
        city,
        state
      ]);
}

class LoadingEvent extends ShippingAddressEvent {
  String pincode;
  LoadingEvent(this.pincode):super([pincode]);
}