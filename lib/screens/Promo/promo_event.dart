import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/data/models/showCartModel.dart';

class PromoEvent extends BaseEvent{
  PromoEvent([List props = const []]) : super(props);
}

class LoadEvent extends PromoEvent {}

class LoadingEvent extends PromoEvent {
  List<ShowShoppingCartData>? cart_items;
  double cart_value;
  String promo;
  LoadingEvent(this.cart_items, this.cart_value, this.promo):super([cart_items, cart_value, promo]);
}
