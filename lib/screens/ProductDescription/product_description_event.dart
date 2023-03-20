import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';

class ProductDescriptionEvent extends BaseEvent{
  ProductDescriptionEvent([List props = const []]) : super(props);
}

class LoadEvent extends ProductDescriptionEvent {
  String pid;
  LoadEvent(this.pid):super([pid]);
}

class LoadingEvent extends ProductDescriptionEvent {
  String pincode;
  LoadingEvent(this.pincode):super([pincode]);
}

class ProgressEvent extends ProductDescriptionEvent {
  String sku;
  String quantity;
  ProgressEvent(this.sku, this.quantity):super([sku, quantity]);
}

class AddToFavouriteEvent extends ProductDescriptionEvent{
  ProductDescriptionModel? productDescriptionModel;
  AddToFavouriteEvent(this.productDescriptionModel):super([productDescriptionModel]);
}

class CountingEvent extends ProductDescriptionEvent {}

class RecommendingEvent extends ProductDescriptionEvent {
  String pid;
  RecommendingEvent(this.pid):super([pid]);
}

class BannerEvent extends ProductDescriptionEvent {}

