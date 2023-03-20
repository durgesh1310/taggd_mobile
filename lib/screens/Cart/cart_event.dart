import 'package:ouat/BaseBloc/base_event.dart';

class CartEvent extends BaseEvent{
  CartEvent([List props = const []]) : super(props);
}

class LoadCartEvent extends CartEvent {
}

class LoadDeliveryEvent extends CartEvent {
  String cart_value;
  LoadDeliveryEvent(this.cart_value):super([cart_value]);
}


class LoadingEvent extends CartEvent {
  String sku;
  LoadingEvent(this.sku):super([sku]);
}

class GuestEvent extends CartEvent {
  String mobile;
  String email;
  GuestEvent(this.mobile, this.email):super([mobile, email]);
}

class ProgressEvent extends CartEvent {
  String sku;
  String quantity;
  ProgressEvent(this.sku, this.quantity):super([sku, quantity]);
}

class WishlistingEvent extends CartEvent{
  int product_id;
  WishlistingEvent(this.product_id) : super([product_id]);
}

class CountingEvent extends CartEvent {}

class IsEmailEvent extends CartEvent {
  String email;
  IsEmailEvent(this.email):super([email]);
}

class BannerEvent extends CartEvent {}


