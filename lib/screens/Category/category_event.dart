import 'package:ouat/BaseBloc/base_event.dart';

class CategoryEvent extends BaseEvent{
  CategoryEvent([List props = const []]) : super(props);
}

class LoadEvent extends CategoryEvent {}