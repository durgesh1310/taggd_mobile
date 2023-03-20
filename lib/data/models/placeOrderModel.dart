import 'message.dart';

class PlaceOrderModel {
  bool? success;
  List<Message>? message;
  String? code;
  PlaceOrderData? data;

  PlaceOrderModel({this.success, this.message, this.code, this.data});

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new PlaceOrderData.fromJson(json['data']) : null;
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


class PlaceOrderData {
  int? order_id;
  String? order_status;
  String? third_party_order_id;

  PlaceOrderData({this.order_id, this.order_status, this.third_party_order_id});

  PlaceOrderData.fromJson(Map<String, dynamic> json) {
    order_id = json['order_id'] ?? 0;
    order_status = json['order_status'] ?? "";
    third_party_order_id = json['third_party_order_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.order_id;
    data['order_status'] = this.order_status;
    data['third_party_order_id'] = this.third_party_order_id;
    return data;
  }
}