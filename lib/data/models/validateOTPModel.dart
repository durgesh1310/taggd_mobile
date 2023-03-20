import 'dart:convert';

class ValidateOTPModel {
  bool success = false;
  String? code;
  ValidateOTPData? data;

  ValidateOTPModel({
    required this.success,
    required this.code,
    this.data});

  ValidateOTPModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    data = json['data'] != null ? new ValidateOTPData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ValidateOTPData {
  int? otpLength;
  String? notificationMessage;
  CustomerDetail? customerDetail;
  String? token;


  ValidateOTPData({this.otpLength, this.notificationMessage,this.customerDetail, this.token});

  ValidateOTPData.fromJson(Map<String, dynamic> json) {
    otpLength = json['otp_length'] ?? 0;
    notificationMessage = json['notification_message'] ?? "";
    customerDetail = json['customer_detail'] != null
        ? new CustomerDetail.fromJson(json['customer_detail'])
        : null;
    token = json['token'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp_length'] = this.otpLength;
    data['notification_message'] = this.notificationMessage;
    if (this.customerDetail != null) {
      data['customer_detail'] = this.customerDetail!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

CustomerDetail userModelFromJson(String str) => CustomerDetail.fromJson(json.decode(str));

String userModelToJson(CustomerDetail data) => json.encode(data.toJson());
class CustomerDetail {
  String? firstName;
  String? lastName;
  String? gender;
  String? mobile;
  String? email;
  int? isActive;
  int? customerId;
  String? token;
  String? userType;
  int? isNewUser;

  CustomerDetail(
      {this.firstName,
        this.lastName,
        this.gender,
        this.mobile,
        this.email,
        this.isActive,
        this.customerId,
        this.token,
        this.userType,
        this.isNewUser
      });

  CustomerDetail.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    gender = json['gender'] ?? "";
    mobile = json['mobile'] ?? "";
    email = json['email'] ?? "";
    isActive = json['is_active'] ?? 0;
    customerId = json['customer_id'] ?? 0;
    token = json['token'] ?? "";
    userType = json['user_type'] ?? "";
    isNewUser = json['is_new_user'] ?? 0;
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
    data['token'] = this.token;
    data['user_type'] = this.userType;
    data['is_new_user'] = this.isNewUser;
    return data;
  }
}