import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/checkOutModel.dart';
import 'package:ouat/data/models/createRazorpayCustomerModel.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/models/placeOrderModel.dart';

abstract class CheckOutState extends BaseState{
  CheckOutState([List props = const []]) : super(props);

}

class SearchInitState extends CheckOutState {}


class Initialized extends CheckOutState {
  @override
  List<Object> get props => [];
}

class CheckOutInitState extends CheckOutState {
  @override
  List<Object> get props => [];
}

class CompletedState extends CheckOutState {
  final CheckOutModel? checkOutModel;
  CompletedState({this.checkOutModel});
  List<Object?> get props => [checkOutModel];
}

class CompletedCheckState extends CheckOutState {
  final PincodeValidationModel? pincodeValidationModel;
  CompletedCheckState({this.pincodeValidationModel});
  List<Object?> get props => [pincodeValidationModel];
}

class NotAuthorisedState extends CheckOutState {
  @override
  List<Object> get props => [];
}

class GuestState extends CheckOutState{
  final AddToCartModel? profileUpdateModel;
  GuestState({this.profileUpdateModel});
  List<Object?> get props => [profileUpdateModel];
}

class CreateRazorpayCustomerState extends CheckOutState {
  final CreateRazorpayCustomerModel? createRazorpayCustomerModel;
  CreateRazorpayCustomerState({this.createRazorpayCustomerModel});
  List<Object?> get props => [createRazorpayCustomerModel];
}


class ErrorState extends CheckOutState {
  final String message;
  ErrorState(this.message);
}