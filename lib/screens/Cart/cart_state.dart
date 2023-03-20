import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/isEmailExistModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/promoValidModel.dart';
import 'package:ouat/data/models/shippingChargesModel.dart';
import 'package:ouat/data/models/showCartModel.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/deleteCartItemModel.dart';

import '../../data/models/commonBannerModel.dart';

abstract class CartState extends BaseState{
  CartState([List props = const []]) : super(props);

}

class SearchCartInitState extends CartState {}


class Initialized extends CartState {
  @override
  List<Object> get props => [];
}

class CategoryInitState extends CartState {
  @override
  List<Object> get props => [];
}

class CompletedCartState extends CartState {
  final ShowCartModel? showCartModel;
  CompletedCartState({this.showCartModel});
  List<Object?> get props => [showCartModel];
}

class CompletedDeliverState extends CartState {
  final ShippingChargesModel? shippingChargesModel;
  CompletedDeliverState({this.shippingChargesModel});
  List<Object?> get props => [shippingChargesModel];
}

class CompletedCheckState extends CartState {
  final DeleteCartItemModel? deleteCartItemModel;
  CompletedCheckState({this.deleteCartItemModel});
  List<Object?> get props => [deleteCartItemModel];
}

class CompletedAddingState extends CartState {
  final AddToCartModel? addToCartModel;
  CompletedAddingState({this.addToCartModel});
  List<Object?> get props => [addToCartModel];
}

class WishlistingState extends CartState {
  final AddToWishListModel? addToWishListModel;
  WishlistingState({this.addToWishListModel});
  List<Object?> get props => [addToWishListModel];
}

class CountingState extends CartState {
  final OrderStatusModel? orderStatusModel;
  CountingState({this.orderStatusModel});
  List<Object?> get props => [orderStatusModel];
}

class NotAuthorisedState extends CartState {}

class GuestState extends CartState{
  final AddToCartModel? profileUpdateModel;
  GuestState({this.profileUpdateModel});
  List<Object?> get props => [profileUpdateModel];
}

class IsEmailState extends CartState{
  final IsEmailExistModel? isEmailExistModel;
  IsEmailState({this.isEmailExistModel});
  List<Object?> get props => [isEmailExistModel];
}

class BannerState extends CartState {
  final CommonBannerModel? commonBannerModel;
  BannerState({this.commonBannerModel});
  List<Object?> get props => [commonBannerModel];
}

class ErrorBannerState extends CartState {}


class ErrorCartState extends CartState {
  final String message;
  ErrorCartState(this.message);
}

class ErrorDeliverState extends CartState {
  final String message;
  ErrorDeliverState(this.message);
}
