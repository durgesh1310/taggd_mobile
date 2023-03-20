import './message.dart';


class DeleteCartItemModel {
  bool success = false;
  List<Message>? message;
  String? code;
  String? data;

  DeleteCartItemModel({
    required this.success,
    this.message, this.code, this.data});

  DeleteCartItemModel.fromJson(Map<String, dynamic> json) {
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
