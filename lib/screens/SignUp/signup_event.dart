import 'package:ouat/BaseBloc/base_event.dart';

class SignUpEvent extends BaseEvent{
  SignUpEvent([List props = const []]) : super(props);
}

class LoadSignUpEvent extends SignUpEvent {
  String name;
  String gender;
  String email;
  String mobno;
  LoadSignUpEvent(
      this.name,
      this.gender,
      this.email,
      this.mobno
      ):super(
      [
        name,
        gender,
        email,
        mobno
      ]
  );
}

class LoadEvent extends SignUpEvent {
  String phoneNo;
  String otpReason;
  LoadEvent(this.phoneNo, this.otpReason):super([phoneNo,otpReason]);
}