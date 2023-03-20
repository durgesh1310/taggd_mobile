import 'package:ouat/BaseBloc/base_event.dart';


class PromoEvent extends BaseEvent{
  PromoEvent([List props = const []]) : super(props);
}

class LoadEvent extends PromoEvent {}

class LoadScratchCodeEvent extends PromoEvent {}
