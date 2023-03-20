import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/orderStatusV1Model.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/models/placeOrderModel.dart';


abstract class PaymentState extends BaseState{
  PaymentState([List props = const []]) : super(props);

}

class SearchInitState extends PaymentState {}


class Initialized extends PaymentState {
  @override
  List<Object> get props => [];
}

class PaymentInitState extends PaymentState {
  @override
  List<Object> get props => [];
}

class CompletedState extends PaymentState {
  final PlaceOrderModel? placeOrderModel;
  CompletedState({this.placeOrderModel});
  List<Object?> get props => [placeOrderModel];
}

class StatusState extends PaymentState {
  final OrderStatusV1Model? orderStatusV1Model;
  StatusState({this.orderStatusV1Model});
  List<Object?> get props => [orderStatusV1Model];
}


class CompletedCheckState extends PaymentState {
  final PincodeValidationModel? pincodeValidationModel;
  CompletedCheckState({this.pincodeValidationModel});
  List<Object?> get props => [pincodeValidationModel];
}


class ErrorState extends PaymentState {
  final String message;
  ErrorState(this.message);
}