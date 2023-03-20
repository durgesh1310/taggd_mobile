import 'package:ouat/BaseBloc/base_event.dart';

class AccountEvent extends BaseEvent {
  AccountEvent([List props = const []]) : super(props);
}

class LoadEvent extends AccountEvent {}

class DeleteEvent extends AccountEvent {}