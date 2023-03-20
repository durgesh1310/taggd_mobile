import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/orderConfirmationModel.dart';

import '../../data/models/commonBannerModel.dart';

abstract class OrderConfirmationState extends BaseState{
  OrderConfirmationState([List props = const []]) : super(props);

}

class SearchInitState extends OrderConfirmationState {}


class Initialized extends OrderConfirmationState {
  @override
  List<Object> get props => [];
}

class OrderConfirmationInitState extends OrderConfirmationState {
  @override
  List<Object> get props => [];
}

class CompletedState extends OrderConfirmationState {
  final OrderConfirmationModel? orderConfirmationModel;
  CompletedState({this.orderConfirmationModel});
  List<Object?> get props => [orderConfirmationModel];
}

class BannerState extends OrderConfirmationState {
  final CommonBannerModel? commonBannerModel;
  BannerState({this.commonBannerModel});
  List<Object?> get props => [commonBannerModel];
}

class ErrorBannerState extends OrderConfirmationState {}


class ErrorState extends OrderConfirmationState {
  final String message;
  ErrorState(this.message);
}