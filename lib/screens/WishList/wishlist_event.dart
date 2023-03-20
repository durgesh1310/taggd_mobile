import 'package:ouat/BaseBloc/base_event.dart';

class WishListEvent extends BaseEvent{
  WishListEvent([List props = const []]) : super(props);
}

class LoadEvent extends WishListEvent {}

class SizeEvent extends WishListEvent {
  String pid;
  SizeEvent(this.pid):super([pid]);
}

class LoadingEvent extends WishListEvent {
  int product_id;
  LoadingEvent(this.product_id):super([product_id]);
}

class ProgressEvent extends WishListEvent {
  int product_id;
  ProgressEvent(this.product_id):super([product_id]);
}

class ProgressingEvent extends WishListEvent {
  String sku;
  String quantity;
  ProgressingEvent(this.sku, this.quantity):super([sku, quantity]);
}