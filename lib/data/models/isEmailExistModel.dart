import 'message.dart';

class IsEmailExistModel {
  bool success = false;
  List<Message>? message;
  String? code;
  Data? data;

  IsEmailExistModel({required this.success, this.message, this.code, this.data});

  IsEmailExistModel.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? gender;
  String? mobile;
  String? email;
  int? isActive;
  int? customerId;
  String? userType;

  Data(
      {this.firstName,
        this.lastName,
        this.gender,
        this.mobile,
        this.email,
        this.isActive,
        this.customerId,
        this.userType});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    mobile = json['mobile'];
    email = json['email'];
    isActive = json['is_active'];
    customerId = json['customer_id'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['is_active'] = this.isActive;
    data['customer_id'] = this.customerId;
    data['user_type'] = this.userType;
    return data;
  }
}