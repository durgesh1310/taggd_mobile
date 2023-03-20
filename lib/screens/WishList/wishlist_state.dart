import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/deleteWishListModel.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/showWishListModel.dart';
import 'package:ouat/data/models/addToCartModel.dart';


abstract class WishListState extends BaseState{
  WishListState([List props = const []]) : super(props);

}

class SearchInitState extends WishListState {}


class Initialized extends WishListState {
  @override
  List<Object> get props => [];
}

class CategoryInitState extends WishListState {
  @override
  List<Object> get props => [];
}

class CompletedState extends WishListState {
  final ShowWishListModel? showWishListModel;
  CompletedState({this.showWishListModel});
  List<Object?> get props => [showWishListModel];
}

class SizeState extends WishListState {
  final ProductDescriptionModel? productDescriptionModel;
  SizeState({this.productDescriptionModel});
  List<Object?> get props => [productDescriptionModel];
}

class CompletedCheckState extends WishListState {
  final DeleteWishListModel? deleteWishListModel;
  CompletedCheckState({this.deleteWishListModel});
  List<Object?> get props => [deleteWishListModel];
}

class CompletedAddingState extends WishListState {
  final AddToWishListModel? addToWishListModel;
  CompletedAddingState({this.addToWishListModel});
  List<Object?> get props => [addToWishListModel];
}


class CompletedCartState extends WishListState {
  final AddToCartModel? addToCartModel;
  CompletedCartState({this.addToCartModel});
  List<Object?> get props => [addToCartModel];
}

class ErrorState extends WishListState {
  final String message;
  ErrorState(this.message);
}

class NotAuthorisedState extends WishListState {
  @override
  List<Object> get props => [];
}