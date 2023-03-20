import 'package:ouat/BaseBloc/base_event.dart';

class SpecialPageEvent extends BaseEvent{
  SpecialPageEvent([List props = const []]) : super(props);
}

class LoadEvent extends SpecialPageEvent {
  String id;
  LoadEvent(this.id) : super([id]);
}