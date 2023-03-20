import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/customerCreditsModel.dart';

abstract class AccountState extends BaseState {
  AccountState([List props = const []]) : super(props);

}

class AccountInitState extends AccountState {}

class UnInitialized extends AccountState {
  @override
  List<Object> get props => [];
}


class NotAuthorisedState extends AccountState{
  @override
  List<Object> get props => [];

}

class AuthorisedState extends AccountState {
  late String? name;
  late String? email;
  late String? mobile;
  final CustomerCreditsModel? customerCreditsModel;
  AuthorisedState({this.name, this.email, this.mobile, this.customerCreditsModel});
  List<Object?> get props => [name, email, mobile, customerCreditsModel];
}

class DeleteState extends AccountState{
  final AddAddressModel? deleteUserModel;
  DeleteState({this.deleteUserModel});
  List<Object?> get props => [deleteUserModel];
}


class ErrorState extends AccountState {
  final String message;
  ErrorState(this.message);
}
