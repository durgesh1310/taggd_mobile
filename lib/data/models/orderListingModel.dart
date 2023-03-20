import './message.dart';

class OrderListingModel {
  bool? success = false;
  List<Message>? message;
  String? code;
  OrderListingData? data;

  OrderListingModel({
    this.success,
    this.message,
    this.code,
    this.data
  });

  OrderListingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new OrderListingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


class OrderListingData {
  List<OrderListDetailResponse>? orderListDetailResponse;

  OrderListingData({this.orderListDetailResponse});

  OrderListingData.fromJson(Map<String, dynamic> json) {
    if (json['order_list_detail_response'] != null) {
      orderListDetailResponse = [];
      json['order_list_detail_response'].forEach((v) {
        orderListDetailResponse!.add(new OrderListDetailResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderListDetailResponse != null) {
      data['order_list_detail_response'] =
          this.orderListDetailResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderListDetailResponse {
  int? orderId;
  String? orderNumber;
  String? orderDate;
  int? orderTotalPayAmount;
  List<OrderResponseList>? orderResponseList;

  OrderListDetailResponse(
      {
        this.orderId,
        this.orderNumber,
        this.orderDate,
        this.orderTotalPayAmount,
        this.orderResponseList
      });

  OrderListDetailResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'] ?? 0;
    orderNumber = json['order_number'] ?? "";
    orderDate = json['order_date'] ?? "";
    orderTotalPayAmount = json['order_total_pay_amount'] ?? 0;
    if (json['order_response_list'] != null) {
      orderResponseList = [];
      json['order_response_list'].forEach((v) {
        orderResponseList!.add(new OrderResponseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['order_date'] = this.orderDate;
    data['order_total_pay_amount'] = this.orderTotalPayAmount;
    if (this.orderResponseList != null) {
      data['order_response_list'] =
          this.orderResponseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderResponseList {
  String? itemName;
  String? thumbNailImageUrl;
  int? item_pay_amount;
  String? orderStatus;
  String? orderStatusDate;
  int? qty;
  int? itemPayable;

  OrderResponseList(
      {
        this.itemName,
        this.thumbNailImageUrl,
        this.item_pay_amount,
        this.orderStatus,
        this.orderStatusDate,
        this.qty,
        this.itemPayable});

  OrderResponseList.fromJson(Map<String, dynamic> json) {
    itemName = json['item_name'] ?? "";
    thumbNailImageUrl = json['thumb_nail_image_url'] ?? "";
    item_pay_amount = json['item_pay_amount'] ?? 0;
    orderStatus = json['order_status'] ?? "";
    orderStatusDate = json['order_status_date'] ?? "";
    qty = json['qty'] ?? 0;
    itemPayable = json['item_payable'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_name'] = this.itemName;
    data['thumb_nail_image_url'] = this.thumbNailImageUrl;
    data['item_pay_amount'] = this.item_pay_amount;
    data['order_status'] = this.orderStatus;
    data['order_status_date'] = this.orderStatusDate;
    data['qty'] = this.qty;
    data['item_payable'] = this.itemPayable;
    return data;
  }
}

