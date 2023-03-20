import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';


abstract class UpdateAddressState extends BaseState{
  UpdateAddressState([List props = const []]) : super(props);

}

class SearchInitState extends UpdateAddressState {}


class Initialized extends UpdateAddressState {
  @override
  List<Object> get props => [];
}

class CategoryInitState extends UpdateAddressState {
  @override
  List<Object> get props => [];
}

class CompletedAddingState extends UpdateAddressState {
  final AddAddressModel? addAddressModel;
  CompletedAddingState({this.addAddressModel});
  List<Object?> get props => [addAddressModel];
}

class CompletedCheckState extends UpdateAddressState {
  final PincodeValidationModel? pincodeValidationModel;
  CompletedCheckState({this.pincodeValidationModel});
  List<Object?> get props => [pincodeValidationModel];
}

class ErrorState extends UpdateAddressState {
  final String message;
  ErrorState(this.message);
}