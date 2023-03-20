import './message.dart';


class CustomerCreditsModel {
  bool? success;
  List<Message>? message;
  String? code;
  List<CreditsData>? data;

  CustomerCreditsModel({this.success, this.message, this.code, this.data});

  CustomerCreditsModel.fromJson(Map<String, dynamic> json) {
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
        data!.add(new CreditsData.fromJson(v));
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

class CreditsData {
  String? creditName;
  int? amount;
  String? type;

  CreditsData({this.creditName, this.amount, this.type});

  CreditsData.fromJson(Map<String, dynamic> json) {
    creditName = json['credit_name'] == null ? "" : json['credit_name'];
    amount = json['amount'] == null ? 0 : json['amount'];
    type = json['type'] == null ? "" : json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_name'] = this.creditName;
    data['amount'] = this.amount;
    data['type'] = this.type;
    return data;
  }
}