import 'package:ouat/BaseBloc/base_event.dart';

class SendOTPEvent extends BaseEvent{
  SendOTPEvent([List props = const []]) : super(props);
}

class LoadEvent extends SendOTPEvent {
  String phoneNo;
  String otpReason;
  LoadEvent(this.phoneNo, this.otpReason):super([phoneNo,otpReason]);
}