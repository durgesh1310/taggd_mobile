import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/commonBannerModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/models/recommendationModel.dart';


abstract class ProductDescriptionState extends BaseState{
  ProductDescriptionState([List props = const []]) : super(props);

}

class SearchInitState extends ProductDescriptionState {}


class Initialized extends ProductDescriptionState {
  @override
  List<Object> get props => [];
}

class ProductDescriptionInitState extends ProductDescriptionState {
  @override
  List<Object> get props => [];
}

class CompletedState extends ProductDescriptionState {
  final ProductDescriptionModel? productDescriptionModel;
  CompletedState({this.productDescriptionModel});
  List<Object?> get props => [productDescriptionModel];
}

class CompletedCheckState extends ProductDescriptionState {
  final PincodeValidationModel? pincodeValidationModel;
  CompletedCheckState({this.pincodeValidationModel});
  List<Object?> get props => [pincodeValidationModel];
}

class CompletedAddingState extends ProductDescriptionState {
  final AddToCartModel? addToCartModel;
  CompletedAddingState({this.addToCartModel});
  List<Object?> get props => [addToCartModel];
}

class NotAuthorisedState extends ProductDescriptionState{
  @override
  List<Object> get props => [];

}

class CountingState extends ProductDescriptionState {
  final OrderStatusModel? orderStatusModel;
  CountingState({this.orderStatusModel});
  List<Object?> get props => [orderStatusModel];
}

class RecommendingState extends ProductDescriptionState {
  final RecommendationModel? recommendationModel;
  RecommendingState({this.recommendationModel});
  List<Object?> get props => [recommendationModel];
}

class BannerState extends ProductDescriptionState {
  final CommonBannerModel? commonBannerModel;
  BannerState({this.commonBannerModel});
  List<Object?> get props => [commonBannerModel];
}

class ErrorRecommendingState extends ProductDescriptionState {}

class ErrorBannerState extends ProductDescriptionState {}

class FavouriteState extends ProductDescriptionState{
   List<Object?> get props => [];
}
class UnFavouriteState extends ProductDescriptionState{
   List<Object?> get props => [];
}

class ErrorState extends ProductDescriptionState {
  final String message;
  ErrorState(this.message);
}