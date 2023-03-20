import 'message.dart';

class AddAddressModel {
  bool? success;
  List<Message>? message;
  String? code;
  String? data;

  AddAddressModel({this.success, this.message, this.code, this.data});

  AddAddressModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] == null ? "" : json['data'];
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