import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/cancelReasonModel.dart';
import 'package:ouat/data/models/cancelReturnItemModel.dart';
import 'package:ouat/data/models/orderDescriptionModel.dart';
import 'package:ouat/data/models/sizeExchangedModel.dart';
import 'package:ouat/data/models/sizeExchangingModel.dart';


abstract class OrderDescriptionState extends BaseState{
  OrderDescriptionState([List props = const []]) : super(props);

}

class SearchInitState extends OrderDescriptionState {}


class Initialized extends OrderDescriptionState {
  @override
  List<Object> get props => [];
}

class OrderDescriptionInitState extends OrderDescriptionState {
  @override
  List<Object> get props => [];
}

class CompletedState extends OrderDescriptionState {
  final OrderDescriptionModel? orderDescriptionModel;
  CompletedState({this.orderDescriptionModel});
  List<Object?> get props => [orderDescriptionModel];
}

class CancelledReasonState extends OrderDescriptionState {
  final CancelReasonModel? cancelReasonModel;
  CancelledReasonState({this.cancelReasonModel});
  List<Object?> get props => [cancelReasonModel];
}


class DoneState extends OrderDescriptionState {
  final CancelReturnItemModel? cancelReturnItemModel;
  DoneState({this.cancelReturnItemModel});
  List<Object?> get props => [cancelReturnItemModel];
}

class ExchangeState extends OrderDescriptionState {
  final SizeExchangedModel? sizeExchangedModel;
  ExchangeState({this.sizeExchangedModel});
  List<Object?> get props => [sizeExchangedModel];
}

class RadioChangeState extends OrderDescriptionState{
  @override
  List<Object> get props => [];
}

class SizeExchangeState extends OrderDescriptionState{
  final SizeExchangingModel? sizeExchangeModel;
  SizeExchangeState({this.sizeExchangeModel});
  List<Object?> get props => [sizeExchangeModel];
}


class ErrorState extends OrderDescriptionState {
  final String message;
  ErrorState(this.message);
}