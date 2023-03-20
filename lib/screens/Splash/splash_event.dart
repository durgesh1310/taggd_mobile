import 'package:ouat/BaseBloc/base_event.dart';

class SplashActivityEvent extends BaseEvent {
  SplashActivityEvent([List props = const []]) : super(props);
}

class LoadAssetsEvent extends SplashActivityEvent {}

class LoadCategoryEvent extends SplashActivityEvent {}

class LoadCheckLoginEvent extends SplashActivityEvent {}


