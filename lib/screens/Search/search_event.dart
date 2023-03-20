import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/data/models/searchModel.dart';

class SearchEvent extends BaseEvent {
  SearchEvent([List props = const []]) : super(props);
}

class LoadEvent extends SearchEvent {
  String query;
  LoadEvent(this.query) : super([query]);
}

class LoadingEvent extends SearchEvent {
  String query;
  var filterData;
  String sortBy;
  int pageNo;
  bool collection;
  LoadingEvent(this.query, this.filterData, this.sortBy, this.pageNo, this.collection) : super([query, filterData, sortBy, pageNo, collection]);
}

class SearchLoadEvent extends SearchEvent {
  String query;
  var filterData;
  String sortBy;
  int pageNo;

  SearchLoadEvent(this.query, this.filterData, this.sortBy, this.pageNo, )
      : super([query, filterData, sortBy, pageNo,]);
}

class NextSearchLoadEvent extends SearchEvent {
  String query;
  var filterData;
  String sortBy;
  int pageNo;
  List<PlpCard>? plpCard;
  NextSearchLoadEvent(this.query, this.filterData, this.sortBy, this.pageNo, this.plpCard)
      : super([query, filterData, sortBy, pageNo, plpCard]);
}

class NextPlpLoadEvent extends SearchEvent {
  String query;
  var filterData;
  String sortBy;
  int pageNo;
  bool collection;
  List<PlpCard>? plpCard;
  NextPlpLoadEvent(this.query, this.filterData, this.sortBy, this.pageNo, this.collection, this.plpCard)
      : super([query, filterData, sortBy, pageNo, collection, plpCard]);
}

class WishlistingEvent extends SearchEvent{
  bool item_wishlisted;
  int product_id;
  WishlistingEvent(this.item_wishlisted,this.product_id) : super([item_wishlisted, product_id]);
}
