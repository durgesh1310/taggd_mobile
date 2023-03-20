import 'package:ouat/BaseBloc/base_event.dart';

class OrderDescriptionEvent extends BaseEvent{
  OrderDescriptionEvent([List props = const []]) : super(props);
}

class LoadEvent extends OrderDescriptionEvent {
  String? order_number;
  LoadEvent(this.order_number):super([order_number]);
}

class LoadingEvent extends OrderDescriptionEvent {
  String? order_number;
  LoadingEvent(this.order_number):super([order_number]);
}

class ProgressEvent extends OrderDescriptionEvent {
  String? order_number;
  ProgressEvent(this.order_number):super([order_number]);
}

class ProcessingEvent extends OrderDescriptionEvent {
  int order_item_id;
  String sku;
  int reason_id;
  String refund_type;
  ProcessingEvent(this.order_item_id, this.sku, this.reason_id, this.refund_type):super([order_item_id, sku, reason_id, refund_type]);
}

class ProcessEvent extends OrderDescriptionEvent {
  int order_item_id;
  String sku;
  int reason_id;
  String refund_type;
  ProcessEvent(this.order_item_id, this.sku, this.reason_id, this.refund_type):super([order_item_id, sku, reason_id, refund_type]);
}

class ProgressingEvent extends OrderDescriptionEvent {
  int order_item_id;
  String sku;
  int reason_id;
  ProgressingEvent(this.order_item_id, this.sku, this.reason_id):super([order_item_id, sku, reason_id]);
}

class ExchangeEvent extends OrderDescriptionEvent {
  String? order_number;
  ExchangeEvent(this.order_number):super([order_number]);
}

class SizeExchangeEvent extends OrderDescriptionEvent{
  int order_item_id;
  SizeExchangeEvent(this.order_item_id):super([order_item_id]);
}

