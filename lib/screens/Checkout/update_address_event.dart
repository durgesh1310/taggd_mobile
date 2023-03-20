import 'package:ouat/BaseBloc/base_event.dart';

class UpdateAddressEvent extends BaseEvent{
  UpdateAddressEvent([List props = const []]) : super(props);
}


class ProgressEvent extends UpdateAddressEvent {
  String fullname;
  int pincode;
  String address;
  String landmark;
  String mobile;
  String city;
  String state;
  int address_id;
  ProgressEvent(
      this.fullname,
      this.pincode,
      this.address,
      this.landmark,
      this.mobile,
      this.city,
      this.state,
      this.address_id
      ):
        super([
        fullname,
        pincode,
        address,
        landmark,
        mobile,
        city,
        state,
        address_id
      ]);
}

class LoadingEvent extends UpdateAddressEvent {
  String pincode;
  LoadingEvent(this.pincode):super([pincode]);
}