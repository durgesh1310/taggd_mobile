import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/categoryModel.dart';

abstract class CategoryState extends BaseState{
CategoryState([List props = const []]) : super(props);

}

class SearchInitState extends CategoryState {}


class Initialized extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryInitState extends CategoryState {
  @override
  List<Object> get props => [];
}

class CompletedState extends CategoryState {
  final CategoryModel? categoryModel;
  CompletedState({this.categoryModel});
  List<Object?> get props => [categoryModel];
}

class ErrorState extends CategoryState {
  final String message;
  ErrorState(this.message);
}