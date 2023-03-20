import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/searchModel.dart';


abstract class SearchState extends BaseState{
  SearchState([List props = const []]) : super(props);

}

class SearchInitState extends SearchState {}


class Initialized extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchInitialState extends SearchState {
  @override
  List<Object> get props => [];
}

class CompletedState extends SearchState {
  final SearchModel? searchModel;
  CompletedState({this.searchModel});
  List<Object?> get props => [searchModel];
}

class SearchLoadingState extends SearchState{}

class WishlistingState extends SearchState {
  final AddToWishListModel? addToWishListModel;
  WishlistingState({this.addToWishListModel});
  List<Object?> get props => [addToWishListModel];
}

class UnFavouriteState extends SearchState{
  List<Object?> get props => [];
}

class RedirectingState extends SearchState{}

class NotAuthorisedState extends SearchState {}

class ErrorState extends SearchState {
  final String message;
  ErrorState(this.message);
}