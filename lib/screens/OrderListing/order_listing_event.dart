import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/data/models/orderListingModel.dart';

class OrderListingEvent extends BaseEvent{
  OrderListingEvent([List props = const []]) : super(props);
}

class LoadEvent extends OrderListingEvent {
  int pageNo;
  LoadEvent(this.pageNo) : super([pageNo]);
}

class NextSearchLoadEvent extends OrderListingEvent {
  int pageNo;
  List<OrderListDetailResponse>? orderListDetailResponse;
  NextSearchLoadEvent(this.pageNo, this.orderListDetailResponse)
      : super([pageNo, orderListDetailResponse]);
}

class CountingEvent extends OrderListingEvent {}
