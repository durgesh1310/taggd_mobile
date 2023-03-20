import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/selectAddressModel.dart';

abstract class SelectAddressState extends BaseState{
  SelectAddressState([List props = const []]) : super(props);

}

class SearchInitState extends SelectAddressState {}


class Initialized extends SelectAddressState {
  @override
  List<Object> get props => [];
}

class SearchInitialState extends SelectAddressState {
  @override
  List<Object> get props => [];
}

class CompletedState extends SelectAddressState {
  final SelectAddressModel? selectAddressModel;
  CompletedState({this.selectAddressModel});
  List<Object?> get props => [selectAddressModel];
}

class EmptyState extends SelectAddressState {}

class DeleteState extends SelectAddressState {
  final AddAddressModel? deleteAddressModel;
  DeleteState({this.deleteAddressModel});
  List<Object?> get props => [deleteAddressModel];
}

class ErrorState extends SelectAddressState {
  final String message;
  ErrorState(this.message);
}