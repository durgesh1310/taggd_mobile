import 'package:ouat/BaseBloc/base_event.dart';

class OrderConfirmationEvent extends BaseEvent{
  OrderConfirmationEvent([List props = const []]) : super(props);
}

class LoadEvent extends OrderConfirmationEvent {
  int order_id;
  LoadEvent(this.order_id):super([order_id]);
}

class BannerEvent extends OrderConfirmationEvent {}
