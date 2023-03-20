import './message.dart';

class CreateRazorpayCustomerModel {
  bool? success;
  List<Message>? message;
  String? code;
  Data? data;

  CreateRazorpayCustomerModel(
      {this.success, this.message, this.code, this.data});

  CreateRazorpayCustomerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    else{
      message = [];
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
  String? pgCustomerId;

  Data({this.pgCustomerId});

  Data.fromJson(Map<String, dynamic> json) {
    pgCustomerId = json['pg_customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pg_customer_id'] = this.pgCustomerId;
    return data;
  }
}