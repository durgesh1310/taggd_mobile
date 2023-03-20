import './message.dart';

class PromoListModel {
  bool? success;
  List<Message>? message;
  String? code;
  List<PromoListData>? data;

  PromoListModel({this.success, this.message, this.code, this.data});

  PromoListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new PromoListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromoListData {
  String? code;
  String? name;
  String? description;

  PromoListData({this.code, this.name, this.description});

  PromoListData.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? "";
    name = json['name'] ?? "";
    description = json['description'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}