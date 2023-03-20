import 'message.dart';

class SendOTPModel {
  bool? success;
  List<Message>? message;
  String? code;
  SendOTPData? data;

  SendOTPModel({
    this.success,
    this.message,
    this.code,
    this.data
  });

  SendOTPModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new SendOTPData.fromJson(json['data']) : null;
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


class SendOTPData {
  int? otpLength;
  String? notificationMessage;

  SendOTPData({
    required this.otpLength,
    required this.notificationMessage
  });

  SendOTPData.fromJson(Map<String, dynamic> json) {
    otpLength = json['otp_length'] ?? 0;
    notificationMessage = json['notification_message'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp_length'] = this.otpLength;
    data['notification_message'] = this.notificationMessage;
    return data;
  }
}