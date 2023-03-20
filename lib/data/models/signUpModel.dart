import './message.dart';

class SignUpModel {
  bool success = false;
  List<Message>? message;
  String? code;
  int? data;

  SignUpModel({
    required this.success,
    this.message,
    required this.code, this.data});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'];
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

