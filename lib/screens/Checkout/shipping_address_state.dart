import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';


abstract class ShippingAddressState extends BaseState{
  ShippingAddressState([List props = const []]) : super(props);

}

class SearchInitState extends ShippingAddressState {}


class Initialized extends ShippingAddressState {
  @override
  List<Object> get props => [];
}

class CategoryInitState extends ShippingAddressState {
  @override
  List<Object> get props => [];
}

class CompletedAddingState extends ShippingAddressState {
  final AddAddressModel? addAddressModel;
  CompletedAddingState({this.addAddressModel});
  List<Object?> get props => [addAddressModel];
}

class CompletedCheckState extends ShippingAddressState {
  final PincodeValidationModel? pincodeValidationModel;
  CompletedCheckState({this.pincodeValidationModel});
  List<Object?> get props => [pincodeValidationModel];
}

class ErrorState extends ShippingAddressState {
  final String message;
  ErrorState(this.message);
}