import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/promoListModel.dart';
import 'package:ouat/data/models/promoValidModel.dart';


abstract class PromoState extends BaseState{
  PromoState([List props = const []]) : super(props);

}

class SearchInitState extends PromoState {}


class Initialized extends PromoState {
  @override
  List<Object> get props => [];
}

class CategoryInitState extends PromoState {
  @override
  List<Object> get props => [];
}

class CompletedState extends PromoState {
  final PromoListModel? promoListModel;
  CompletedState({this.promoListModel});
  List<Object?> get props => [promoListModel];
}

class EmptyState extends PromoState {}


class CompletedCheckState extends PromoState {
  final PromoValidModel? promoValidModel;
  CompletedCheckState({this.promoValidModel});
  List<Object?> get props => [promoValidModel];
}


class ErrorState extends PromoState {
  final String message;
  ErrorState(this.message);
}