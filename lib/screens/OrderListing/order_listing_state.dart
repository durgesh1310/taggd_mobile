import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/orderListingModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';


abstract class OrderListingState extends BaseState{
  OrderListingState([List props = const []]) : super(props);

}

class SearchInitState extends OrderListingState {}


class Initialized extends OrderListingState {
  @override
  List<Object> get props => [];
}

class SearchInitialState extends OrderListingState {
  @override
  List<Object> get props => [];
}

class CompletedState extends OrderListingState {
  final OrderListingModel? orderListingModel;
  final HomeModel? homeModel;
  final SortBarModel? sortBarModel;
  CompletedState({this.orderListingModel,this.homeModel, this.sortBarModel});
  List<Object?> get props => [orderListingModel, homeModel , sortBarModel];
}

class NotAuthorisedState extends OrderListingState {
  @override
  List<Object> get props => [];
}

class CountingState extends OrderListingState {
  final OrderStatusModel? orderStatusModel;
  CountingState({this.orderStatusModel});
  List<Object?> get props => [orderStatusModel];
}

class LoadingState extends OrderListingState{}

class NoMoreItemState extends OrderListingState{}

class ErrorState extends OrderListingState {
  final String message;
  ErrorState(this.message);
}