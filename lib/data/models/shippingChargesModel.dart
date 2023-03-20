import 'message.dart';

class ShippingChargesModel {
  bool? success;
  List<Message>? message;
  String? code;
  double? data;

  ShippingChargesModel({this.success, this.message, this.code, this.data});

  ShippingChargesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['data'] = this.data;
    return data;
  }
}