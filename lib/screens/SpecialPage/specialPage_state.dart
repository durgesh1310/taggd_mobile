import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/homeModel.dart';

abstract class SpecialPageState extends BaseState{
  SpecialPageState([List props = const []]) : super(props);

}

class SearchInitState extends SpecialPageState {}


class Initialized extends SpecialPageState {
  @override
  List<Object> get props => [];
}

class SpecialPageInitState extends SpecialPageState {
  @override
  List<Object> get props => [];
}

class CompletedState extends SpecialPageState {
  final HomeModel? homeModel;
  CompletedState({this.homeModel});
  List<Object?> get props => [homeModel];
}

class ErrorState extends SpecialPageState {
  final String message;
  ErrorState(this.message);
}