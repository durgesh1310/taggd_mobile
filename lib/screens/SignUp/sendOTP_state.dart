import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/sendOTPModel.dart';


abstract class SendOTPState extends BaseState{
  SendOTPState([List props = const []]) : super(props);

}

class SearchInitState extends SendOTPState {}


class Initialized extends SendOTPState {
  @override
  List<Object> get props => [];
}

class SendOTPInitState extends SendOTPState {
  @override
  List<Object> get props => [];
}

class CompletedState extends SendOTPState {
  final SendOTPModel? sendOTPModel;
  CompletedState({this.sendOTPModel});
  List<Object?> get props => [sendOTPModel];
}

class MessageState extends SendOTPState{
  final SendOTPModel? sendOTPModel;
  MessageState({this.sendOTPModel});
  List<Object?> get props => [sendOTPModel];
}


class ErrorState extends SendOTPState {
  final String message;
  ErrorState(this.message);
}