import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/signUpModel.dart';
import 'package:ouat/data/models/sendOTPModel.dart';


abstract class SignUpState extends BaseState{
  SignUpState([List props = const []]) : super(props);

}

class SearchInitialState extends SignUpState {}


class Initialized extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpInitState extends SignUpState {
  @override
  List<Object> get props => [];
}

class CompletedSignUpState extends SignUpState {
  final SignUpModel? signUpModel;
  CompletedSignUpState({this.signUpModel});
  List<Object?> get props => [signUpModel];
}

class CompletedState extends SignUpState {
  final SendOTPModel? sendOTPModel;
  CompletedState({this.sendOTPModel});
  List<Object?> get props => [sendOTPModel];
}

class MessageState extends SignUpState{
  final SendOTPModel? sendOTPModel;
  MessageState({this.sendOTPModel});
  List<Object?> get props => [sendOTPModel];
}

class ErrorSignUpState extends SignUpState {
  final String message;
  ErrorSignUpState(this.message);
}