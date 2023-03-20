import 'package:ouat/BaseBloc/base_event.dart';

class ValidateOTPEvent extends BaseEvent{
  ValidateOTPEvent([List props = const []]) : super(props);
}

//class LoadEvent extends ValidateOTPEvent {}

class OtpVerifyEvent extends ValidateOTPEvent{
  String otp;
  String phoneNo;
  String otpReason;
  OtpVerifyEvent(this.otp,this.phoneNo, this.otpReason):super([otp,phoneNo,otpReason]);
}

class MergeEvent extends ValidateOTPEvent{}

class FirstEvent extends ValidateOTPEvent {}