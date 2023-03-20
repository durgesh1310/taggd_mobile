import './message.dart';

class SizeExchangedModel {
  bool? success;
  List<Message>? message;
  String? code;
  Data? data;

  SizeExchangedModel({this.success, this.message, this.code, this.data});

  SizeExchangedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? orderItemId;
  String? sku;
  Null? createdAt;
  Null? createdBy;

  Data({this.orderItemId, this.sku, this.createdAt, this.createdBy});

  Data.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    sku = json['sku'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderItemId'] = this.orderItemId;
    data['sku'] = this.sku;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    return data;
  }
}