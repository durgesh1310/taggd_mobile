import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';


abstract class ValidateOTPState extends BaseState{
  ValidateOTPState([List props = const []]) : super(props);

}

class ValidateSearchInitState extends ValidateOTPState {}


class Initialized extends ValidateOTPState {
  @override
  List<Object> get props => [];
}

class ValidateOTPInitState extends ValidateOTPState {
  @override
  List<Object> get props => [];
}

class CompletedValidateState extends ValidateOTPState {
  final ValidateOTPModel? validateOTPModel;
  CompletedValidateState({this.validateOTPModel});
  List<Object?> get props => [validateOTPModel];
}

class CompletedMergeState extends ValidateOTPState {
  final AddToCartModel? addToMergeCartModel;
  CompletedMergeState({this.addToMergeCartModel});
  List<Object?> get props => [addToMergeCartModel];
}

class FirstLoginCreditsState extends ValidateOTPState{
  final AddToCartModel? addToCartModel;
  FirstLoginCreditsState({this.addToCartModel});
  List<Object?> get props => [addToCartModel];
}

class OnceLoggedState extends ValidateOTPState {}


class ErrorState extends ValidateOTPState {
  final String message;
  ErrorState(this.message);
}