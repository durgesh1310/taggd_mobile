import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import '../../data/models/scratchCardsModel.dart';
import '../../data/models/scratchCodeModel.dart';



abstract class ScratchCardState extends BaseState{
  ScratchCardState([List props = const []]) : super(props);

}

class SearchInitState extends ScratchCardState {}


class Initialized extends ScratchCardState {
  @override
  List<Object> get props => [];
}

class CompletedState extends ScratchCardState {
  final ScratchCardsModel? scratchCardsModel;
  CompletedState({this.scratchCardsModel});
  List<Object?> get props => [scratchCardsModel];
}

class CompletedCodeState extends ScratchCardState {
  final ScratchCodeModel? scratchCodeModel;
  CompletedCodeState({this.scratchCodeModel});
  List<Object?> get props => [scratchCodeModel];
}

class NotAuthorisedState extends ScratchCardState {
  @override
  List<Object> get props => [];
}


class ErrorState extends ScratchCardState {
  final String message;
  ErrorState(this.message);
}